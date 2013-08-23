Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47F6629DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 10:27:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B2C38F8049
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 08:27:23 -0700 (PDT)
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com
	[209.85.215.52]) by cuda.sgi.com with ESMTP id Qbp5jC5I5A0yJh7f
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Aug 2013 08:27:21 -0700 (PDT)
Received: by mail-la0-f52.google.com with SMTP id ev20so591389lab.39
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 08:27:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130823152058.GR5262@sgi.com>
References: <CAGwuE-p8=UwpGUhgpqkWn4U4jU-KnfC3C19Kqqv7uYLJvubxgQ@mail.gmail.com>
	<20130823152058.GR5262@sgi.com>
Date: Fri, 23 Aug 2013 11:27:19 -0400
Message-ID: <CAGwuE-q5r51t43SxDryReN1EN-w=YLR9ehtWxbhDeRjw3J9AAA@mail.gmail.com>
Subject: Re: Power loss and zero-length files
From: Robert Widmer <robertwidmer@gmail.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 23, 2013 at 11:20 AM, Ben Myers <bpm@sgi.com> wrote:
>
> Hey Robert,
>
> On Fri, Aug 23, 2013 at 10:59:50AM -0400, Robert Widmer wrote:
> > I had a script that updated several files on an XFS filesystem using "sed
> > -i", and someone decided to power cycle the box without a sync after
> > running the script, and found that all the files that were updated were now
> > zero-length.
>
> How did they power cycle the box?  With a 'shutdown -h now' you shouldn't have
> this behavior, but resetting or unplugging the machine is a different matter.

The person ran the script, unplugged the machine (instead of shutting
it down like they were told), and boxed it up.


> > Curious, I ran the following script to try and isolate the behavior:
> >
> >
> > #!/usr/bin/perl
> >
> > my $dir = "/home/$ENV{USER}/XFSTest";
> > mkdir $dir;
> > chdir $dir;
> >
> > my $filecount = 100;
> > my $tmpfile = 'file.tmp';
> >
> > while (1) {
> >     for (my $i=0; $i<$filecount; $i++) {
> > my $filename = "file.$i";
> > open(OUT, ">", $tmpfile);
> >         print OUT "Time:".localtime."\n";
> >         close OUT;
> > rename $tmpfile, $filename;
> >     }
> > }
> >
> >
> > On the following release/kernels in a VM:
> >
> > Fedora 16 w/kernel 3.1.0-7.fc16.x86_64
> > Fedora 16 w/kernel 3.6.11-4.fc16.x86_64
> > Fedora 19 w/kernel 3.10-7.200.fc19.x86_64
> > Ubuntu 13.04 w/kernel 3.8.0-19-generic
> >
> >
> > And after a power cycle, all the files are zero-length with no extents.
> >
> > (CentOS 6.4 w/kernel 2.6.32-358.14.1.el6.centos.plus.x86_64 has the binary
> > NULLS)
> >
> > Barriers are not disabled and drive cache:
> > [    2.145011] sd 2:0:0:0: [sda] Cache data unavailable
> > [    2.145013] sd 2:0:0:0: [sda] Assuming drive cache: write through
> >
> >
> > The closest thing I can find in the documentation is the XFS FAQ which
> > mentions "you are looking at an inode which was flushed out, but whose data
> > was not", which seems to indicate that the inode writes and data writes are
> > not done in order, but nothing explicitly documents this.
>
> You have it correct.  The inode writes are a separate from the data writes.
>
> > Is this expected behavior?
> >
> > I've added a sync to the end of my script to try and ensure this does not
> > happen again, and losing some amount of data after a power loss is
> > expected, but it seems counter-intuitive that the inode/data writes are not
> > done in order and that rapid file changes can result in such a large number
> > of files being zero-length.
>
> For a reset or hard power cycle this is the expected behavior.  The inode will
> have been logged when it was created and is likely to be written out before the
> data.  Unless you issue an fsync, the data will be sitting around in cache
> until the kernel decides to write the pages out, and only then is the size
> updated.  Adding the fsync is the right thing to do.  ;)

Okey dokey, I'll be more vigilant in making sure my changes are
synced. Thanks for the quick response.


> Regards,
>         Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
