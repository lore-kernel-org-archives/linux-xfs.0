Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0NIheL3215451 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 12:43:40 -0600
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85E841859CF0
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 10:42:56 -0800 (PST)
Received: from an-out-0708.google.com (an-out-0708.google.com
	[209.85.132.250]) by cuda.sgi.com with ESMTP id
	daULyqBlxoqt0WCb for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2009 10:42:56 -0800 (PST)
Received: by an-out-0708.google.com with SMTP id d11so720944and.32
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 10:42:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090120203319.GA7103@infradead.org>
References: <20090110143924.GA25900@infradead.org>
	<20090110152803.GA7469@infradead.org> <20090110221459.GA8873@orion>
	<20090111104659.GB8071@disturbed>
	<a4423d670901111648w26e86baajcf7b6d98ff37d043@mail.gmail.com>
	<20090112034550.GI8071@disturbed>
	<a4423d670901120008j728af9cdrbed8bbb938117ea3@mail.gmail.com>
	<20090112211848.GL8071@disturbed>
	<a4423d670901201054t3e48ece2ned4a7e3254250fce@mail.gmail.com>
	<20090120203319.GA7103@infradead.org>
Date: Fri, 23 Jan 2009 21:34:36 +0300
Message-ID: <a4423d670901231034k6971ed91tbed3d6eab05d7285@mail.gmail.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

2009/1/20 Christoph Hellwig <hch@infradead.org>:
> On Tue, Jan 20, 2009 at 09:54:44PM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> Is it a new bug?
>> It is pre-2.6.29-rc1 kernel, which was supossed to be free of the bug
>> "fs_is_ok, file: fs/xfs/xfs_btree.c, line: 3327"
>
> From the trace it's a post-btree consolidation kernel, so all the bugs
> in -rc1 are there, too.  It looks like this is the readahead type
> cockup that Geert noticed, so this particular one should be fixed in
> -rc2.
>
> I would strongly recommend to just turn on CNFIG_LBD for post-2.6.28
> kernels for now as all the problems showing up are without CONFIG_LBD.
Yes, both bugs do not appear on kernel with CONFIG_LBD=y.

But I do not need LBD. Does XFS strongly require LBD?
Should I always turn it on even if I do not have files or devices of size 2Tb+ ?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
