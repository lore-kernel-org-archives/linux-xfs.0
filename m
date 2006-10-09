Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 16:08:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k99N7vaG013392
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 16:07:57 -0700
Received: from mx2.quantum.com (mx2.quantum.com [146.174.252.112])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E3B1486FD3
	for <xfs@oss.sgi.com>; Mon,  9 Oct 2006 14:53:24 -0700 (PDT)
Message-ID: <452AC4BE.6090905@xfs.org>
Date: Mon, 09 Oct 2006 16:53:02 -0500
From: Steve Lord <lord@xfs.org>
MIME-Version: 1.0
Subject: Re: Directories > 2GB
References: <20061004165655.GD22010@schatzie.adilger.int>
In-Reply-To: <20061004165655.GD22010@schatzie.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Andreas Dilger wrote:
> For ext4 we are exploring the possibility of directories being larger
> than 2GB in size.  For ext3/ext4 the 2GB limit is about 50M files, and
> the 2-level htree limit is about 25M files (this is a kernel code and not
> disk format limit).
> 
> Amusingly (or not) some users of very large filesystems hit this limit
> with their HPC batch jobs because they have 10,000 or 128,000 processes
> creating files in a directory on an hourly basis (job restart files,
> data dumps for visualization, etc) and it is not always easy to change
> the apps.
> 
> My question (esp. for XFS folks) is if anyone has looked at this problem
> before, and what kind of problems they might have hit in userspace and in
> the kernel due to "large" directory sizes (i.e. > 2GB).  It appears at
> first glance that 64-bit systems will do OK because off_t is a long
> (for telldir output), but that 32-bit systems would need to use O_LARGEFILE
> when opening the file in order to be able to read the full directory
> contents.  It might also be possible to return -EFBIG only in the case
> that telldir is used beyond 2GB (the LFS spec doesn't really talk about
> large directories at all).
> 

My first thought is to run screaming for the hills when user's want this.
In a previous life we had a customer in the US Gov who decided to
put all their 700 million files in one directory. Then they had a
double disk unreported raid failure (raid vendors fault). The
filesystem repair ran for 7 days and a heck of a lot of files
ended up in lost+found. Fortunately they had the huge amount of
memory and process address space available to run repair.

Anyone who does this and has any sense does not allow any sort of
scanning of the namespace (i.e. anything using readdir). You tend
to run out of process address space before you have read the
directory.

You might want to think about keeping the directory a little
more contiguous than individual disk blocks. XFS does have
code in it to allocate the directory in chunks larger than
a single file system block. It does not get used on linux
because the code was written under the assumption you can
see the whole chunk as a single piece of memory which does not
work to well in the linux kernel.

Steve
