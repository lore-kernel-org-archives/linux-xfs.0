Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B0717CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 13:01:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39333304039
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 11:01:33 -0700 (PDT)
Received: from hauki.tapanitarvainen.fi (hauki.tapanitarvainen.fi
	[80.68.90.32]) by cuda.sgi.com with ESMTP id GYpSksxuJ27ijV2W
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Sep 2015 11:01:30 -0700 (PDT)
Date: Thu, 10 Sep 2015 21:01:28 +0300
From: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Subject: Re: "This is a bug."
Message-ID: <20150910180128.GE18940@tarvainen.info>
References: <20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
	<20150910150525.GD27863@bfoster.bfoster>
	<20150910175220.GD18940@tarvainen.info>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910175220.GD18940@tarvainen.info>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2015 at 08:52:20PM +0300, Tapani Tarvainen (tapani@tapanitarvainen.fi) wrote:

> Also, it turns out I have another similar case: another filesystem
> (in the same RAID set) failed also, even though it'd initially
> mounted without problems. Now it shows the same symptoms,
> neither mount nor repair works (have't tried repair -L yet).

Apparently it only failed after someone tried to write on it.

Potentially interesting stuff from dmesg:

[31604.130052] XFS (dm-4): xfs_da_do_buf: bno 8388608 dir: inode 964
[31604.130080] XFS (dm-4): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
[31604.130126] XFS (dm-4): Internal error xfs_da_do_buf(1) at line 2011 of file /build/linux-4wkEzn/
linux-3.2.68/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0371b67
[31604.130127] 
[31604.130213] Pid: 18082, comm: du Not tainted 3.2.0-4-amd64 #1 Debian 3.2.68-1+deb7u1
[...]

-- 
Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
