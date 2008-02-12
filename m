Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 06:15:28 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1CEFH35030257
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 06:15:17 -0800
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8952E5C7E2C
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 06:15:40 -0800 (PST)
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.191]) by cuda.sgi.com with ESMTP id 4HusHHAPZ0ksoYDw for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 06:15:40 -0800 (PST)
Received: by ti-out-0910.google.com with SMTP id d10so477678tib.18
        for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 06:15:39 -0800 (PST)
Message-ID: <1a4a774c0802120551w523ecbb5l8fc5c73d22b6424b@mail.gmail.com>
Date: Tue, 12 Feb 2008 14:51:15 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: inode size benchmarking
In-Reply-To: <20080212121518.GD155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0802120337x55fa2eb6qb7d52511fba3d11c@mail.gmail.com>
	 <20080212121518.GD155407@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Feb 12, 2008 1:15 PM, David Chinner <dgc@sgi.com> wrote:
> On Tue, Feb 12, 2008 at 12:37:36PM +0100, Christian Røsnes wrote:
> > The test server used:
> >
> >  * Debian 4 (Etch)
> >  * Kernel: Debian 2.6.18-6-amd64 #1 SMP Wed Jan 23 06:27:23 UTC 2008
> > x86_64 GNU/Linux
> >  * CPU: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
> >  * MEM: 4GB RAM
> >  * DISK: DELL MD1000 7 disks (1TB SATA) in RAID5. PERC6/E controller
> >  * The test partition is 6TB.
>                            ^^^
>
> This does, though.
>
> With 256 byte inodes, the allocator changes behaviour at filesystem
> sizes > 1TB to keep inodes at smaller than 32 bits. This change
> means that data is no longer close to the inodes, thereby seeking
> the disks more as it moves between writing data and writing inodes.
>
> With 2k inodes, that change doesn't occur until 8TB in size (as that
> is the 32bit inode number limit with 2k inodes), so the allocator is
> still keeping inode+data locality as close as possible on a fs size
> of 6TB.
>
> I suggest running the 256 byte inode numbers again with the "inode64"
> mount option (so the allocator behaves the same as for 2k inodes) and
> seeing how much difference remains....
>

Yes, with mount option inode64 the inode=256 tests now run as fast as
the inode=2048 tests.

Thanks

Christian
