Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62F157F37
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 06:15:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E7E3AC003
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 04:15:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id jbYT8F3Hu4FV0Vf1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 04:15:11 -0700 (PDT)
Date: Sat, 24 Aug 2013 04:15:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Power loss and zero-length files
Message-ID: <20130824111509.GA25684@infradead.org>
References: <CAGwuE-p8=UwpGUhgpqkWn4U4jU-KnfC3C19Kqqv7uYLJvubxgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGwuE-p8=UwpGUhgpqkWn4U4jU-KnfC3C19Kqqv7uYLJvubxgQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Robert Widmer <robertwidmer@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 23, 2013 at 10:59:50AM -0400, Robert Widmer wrote:
> I had a script that updated several files on an XFS filesystem using "sed
> -i", and someone decided to power cycle the box without a sync after
> running the script, and found that all the files that were updated were now
> zero-length.

>From looking at the scripts this looks expected.

> Curious, I ran the following script to try and isolate the behavior:
> 
> 
> #!/usr/bin/perl
> 
> my $dir = "/home/$ENV{USER}/XFSTest";
> mkdir $dir;
> chdir $dir;
> 
> my $filecount = 100;
> my $tmpfile = 'file.tmp';
> 
> while (1) {
>     for (my $i=0; $i<$filecount; $i++) {
> my $filename = "file.$i";
> open(OUT, ">", $tmpfile);
>         print OUT "Time:".localtime."\n";
>         close OUT;
> rename $tmpfile, $filename;
>     }
> }

there is nothing flushing out the data to disk, so if the xfs metadata
commit interval is faster than the the VM dirty writeback time the above
is what you get.  Try doing the perl exquivalent of a fsync/fdatasync on
the OUT fd and things should be on disk.

> Barriers are not disabled and drive cache:
> [    2.145011] sd 2:0:0:0: [sda] Cache data unavailable
> [    2.145013] sd 2:0:0:0: [sda] Assuming drive cache: write through

What kind of disk is this?  You said VM above, so I'd be curious what
kind of VM doesn't support the scsi caching mode pages.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
