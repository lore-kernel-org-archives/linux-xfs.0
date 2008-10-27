Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 04:57:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RBvAoW013552
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:57:12 -0700
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A2F81BD84A6
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:57:09 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184]) by cuda.sgi.com with ESMTP id NFD0CXCiGJkVbBlP for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:57:09 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id h3so759691nfh.42
        for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:57:08 -0700 (PDT)
Message-ID: <5d96567b0810270457g70b63c77re8841ebd1959f7b7@mail.gmail.com>
Date: Mon, 27 Oct 2008 13:57:08 +0200
From: Raz <raziebe@gmail.com>
Subject: Re: does XFS supports hole punching ?
In-Reply-To: <20081022212034.GQ18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0810221040m17d73871iff00d56bf07479c2@mail.gmail.com>
	 <20081022212034.GQ18495@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>, linux-xfs@oss.sgi.com
Cc: Asaf Moses <asafm@bitband.com>, Ofer Kruzel <ofer@bitband.com>, yaronp@bitband.com

Dave Hello
I would be grateful if you help me here. man xfsctl was not clear enough.
I have written a small program that compares the behavior of FREESP
and UNRESERVE.
I create a file size 10M, each 1M is filled with aaa.. 2-nd MB filled with bbb
3-rd with ccc and so on. I am trying to punch a hole with the bellow program
and then inspect the file content, size and block map.

1.  XFS_IOC_FREESP64 seems to be truncating the file and does not
create a hole.
2.  XFS_IOC_UNRESERVE64 creates a hole and leaves the file size
unchanged. as the man
    page says.
/d1/holely:
        0: [0..14335]: 96..14431 14336 blocks
        1: [14336..16383]: hole 2048 blocks
        2: [16384..20479]: 16480..20575 4096 blocks
Do a hole blocks count as a the file-system free space  ? "df" says it does.

1. prior to running
/dev/md1             374255616   1042116 373213500   1% /d1

2. create 10MB file
/dev/md1             374255616   1052416 373203200   1% /d1

3. create a hole
  /dev/md1           374255616   1051332 373204284   1% /d1
1052416-1051332 = 1084k

kernel 2.6.18-8
On Wed, Oct 22, 2008 at 11:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 22, 2008 at 07:40:26PM +0200, Raz wrote:
>> I want to punch  a hole in an exiting file.
>
> Yes. Check the man page for xfsctl(3) and read up on
> XFS_IOC_FREESP64.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
#include <iostream>

using namespace std;

#include <xfs/libxfs.h>
#include <ctype.h>
#include <sys/unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <xfs/xfs_bmap.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int sizeB;
string exename;
int hole_offset;
int hole_size;
char* buf;

int xfs_create_file(string & filename){

	int j=0;
	int fd = open(filename.c_str(),O_RDWR |  O_LARGEFILE | O_CREAT, 0666);
	if (fd<0) {
		perror("open:");
		return -1;
	}
	buf = (char*) malloc(1048576);
	for (int i=0;i<sizeB;i+=1048576,j++){
		memset(buf,'A'+j,1048576);
		if ( write(fd,buf,1048576) < 1048576)
			perror("WRITE");
		printf("[%d,%d]: %c%c%c ... %c%c%c\n",
			   i,
			   i+1048575,
			   buf[0],
			   buf[1],
			   buf[2],
			   buf[1048573],
			   buf[1048574],
			   buf[1048575]);
	}
	close(fd);
	return 0;
}


int xfs_create_hole(string &filename)
{
	int ret;
	printf("PAUSE prior to set hole size at offset %d size %d\n",
		   hole_offset,hole_size);
	getchar();

	int fd = open(filename.c_str(),O_RDWR |  O_LARGEFILE , 0666);
	if (fd<0) {
		perror("OPEN:");
		return -1;
	}
	memset(buf,0,1048576);
	lseek(fd,hole_offset,SEEK_SET);
	ret = read(fd,buf,hole_size);
	if (ret<0) {
		perror("read offset :");
	}
	printf("Prior to hole :first 3 char in offset %d are %c%c%c\n",
		   hole_offset,
		   buf[0],
		   buf[1],
		   buf[2]);


	xfs_flock64_t range;
	range.l_len = hole_size;
	range.l_start = hole_offset ;
	range.l_whence = 0 ;
	int CTL = XFS_IOC_FREESP64;
	//CTL = XFS_IOC_UNRESVSP64;
	if (ioctl(fd,CTL,&range)<0) {
		perror("XFS_IOC_FREESP64:");
		return -1;
	}
	
	close(fd);
	fd = open(filename.c_str(),O_RDONLY |  O_LARGEFILE, 0666);
	if (fd<0) {
		perror("OPEN:");
		return -1;
	}

	for (int i=0;i<sizeB;i+=1048576){
		memset(buf,0,1048576);
		if ( read(fd,buf,1048576) < 1048576)
			perror("READ");
		printf("[%d,%d]: %c%c%c ... %c%c%c\n",
			   i,
			   i+1048575,
			   buf[0],
			   buf[1],
			   buf[2],
			   buf[1048573],
			   buf[1048574],
			   buf[1048575]);
	}
	close(fd);
}


int main (int argc, char *argv[])
{
	exename = string(argv[0]);
	if (argc<5) {
		printf("%s <filename> <size MB> <hole offset MB> <hole size KB>\n",argv[0]);
		return -1;
	}	
	string fname(argv[1]);	
	sizeB  = atoi(argv[2])<<20;
	hole_offset = atoi(argv[3])<<20;
	hole_size = atoi(argv[4])<<10;
	if ( !xfs_create_file(fname) )
			return xfs_create_hole(fname);
	return(0);
}
