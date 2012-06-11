Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BLPkwf139866 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 16:25:46 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	8GX9MRxHzl8gBlw9 (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 14:25:45 -0700 (PDT)
Received: by yenl3 with SMTP id l3so3703489yen.26
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 14:25:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120611162102.GB18432@andromeda.usersys.redhat.com>
References: <4FD5643F.5070801@tlinx.org>
	<20120611132932.GA18432@andromeda.usersys.redhat.com>
	<4FD606C1.1070103@hardwarefreak.com>
	<20120611162102.GB18432@andromeda.usersys.redhat.com>
Date: Mon, 11 Jun 2012 23:25:45 +0200
Message-ID: <CAAxjCEysCwn869nnvVLFB8EG=YdhPwVr9TnEJ57n6FsM_kEMdg@mail.gmail.com>
Subject: Re: block sizes > 4K ?? possible w/large page support?
From: Stefan Ring <stefanrin@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

> I know we can use hugepages with these sizes, but didn't know we can use this as
> common usage. I tried to look at MM code and didn't find anything which would
> make PAGE_SIZE greater than 4096 (at least in x86), but well, I'm not a MM
> developer too.

Me neither, but so much I think I know. With rather recent kernels,
huge pages are used automatically for "normal" memory. There's a
background thread that tries to locate or create adjacent blocks of
memory and create huge pages from these.

But the normal page size as a unit of allocation is still 4KB, and
this will never change (with the current hardware). The page size of
4KB is hard-wired into the architecture, and I'm not aware of any
extension that allows to change that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
