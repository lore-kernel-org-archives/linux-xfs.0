Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 14:31:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1JMUo3G017048
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 14:30:54 -0800
Message-ID: <47BB5873.6040703@sgi.com>
Date: Wed, 20 Feb 2008 09:30:11 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: is xfs good if I have millions of files and thousands of hardlinks?
References: <47BADF75.2070004@wpkg.org>
In-Reply-To: <47BADF75.2070004@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: xfs@oss.sgi.com



Tomasz Chmielewski wrote:
> I have a ext3 filesystem with almost 200 million files (1.2 TB fs, ~65% 
> full); most of the files are hardlinked multiple times, some of them are 
> hardlinked thousands of times.
> 
> I described my problem yesterday on linux-fsdev list:
> 
> http://marc.info/?t=120333985100003

quite a long discussion there .. I haven't read it .. but some comments
below anyway ..

> In general, because new files and hardlinks are being added all the time 
> and the old ones are being removed, this leads to a very, very poor 
> performance.
> 
> When I want to remove a lot of directories/files (which will be 
> hardlinks, mostly), I see disk write speed is down to
> 50 kB/s - 200 kB/s (fifty - two hundred kilobytes/s) - this is the 
> "bandwidth" used during the deletion.
> 
> 
> Also, the filesystem is very fragmented ("dd if=/dev/zero of=some_file 
> bs=64k" writes only about 1 MB/s).
> 
> Will xfs handle a large number of files, including lots of hardlinks, 
> any better than ext3?

defragmenting by copying from the ext3 filesystem to a new filesystem
should help, for a while at least. Whether xfs would have an on-going
performance problem compared to ext3 depends on your usage patterns ..
does "all the time" mean you are continuously adding new files and links
and removing files at a high rate/second? Are multiple threads doing this?
Are all the files the same size? Block-size been tuned?

-- Mark
