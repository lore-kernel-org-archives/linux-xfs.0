Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 16:35:49 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G0ZhHJ019114
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 16:35:44 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89FE1E344FD
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 16:36:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id WeYXcmt42aRiNcmY for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 16:36:07 -0800 (PST)
Message-ID: <47B62FF6.2000903@sandeen.net>
Date: Fri, 15 Feb 2008 18:36:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: rewrite very slow
References: <20080215191636.GC4859@bob.dscon.sk>
In-Reply-To: <20080215191636.GC4859@bob.dscon.sk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: DS <xfs@bob.dscon.sk>
Cc: xfs@oss.sgi.com

DS wrote:
> Hello,
> 
> I need some help to tunning my storage.

...
> TIME 43 sekund


What kernel?  when I test on my 2.6.23.9-85.fc8 and 2.6.22.5 boxes, I
see 2 and 7 seconds for rewrite, respectively.

but granted, on ext3 I get 0 seconds for every run.

Also the difference appears to be O_TRUNC (which the perl script does);
if I code it in c:

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

void main(void)
{
        int i;
        int fd;
        char file[4];

        for (i = 0; i < 100; i++) {
                sprintf(file, "%d.txt", i);
                fd = open(file, O_CREAT|O_RDWR|O_TRUNC, 0644);
                write(fd, "aaaaaaaaaaaaaaaaaaa\n");
                close(fd);
        }
}

rewrite is a bit slower w/ O_TRUNC in place, plenty fast w/o it.  Not
sure about the xfs/ext3 difference... this is probably a side-effect of
flushes xfs put into place on truncate (IIRC?)

-Eric
