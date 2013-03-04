Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BEDA18053
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 16:09:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E156304039
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 14:09:35 -0800 (PST)
Received: from radon.swed.at (a.ns.miles-group.at [95.130.255.143]) by
	cuda.sgi.com with ESMTP id 8dGvH04kOEjXECVE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 14:09:30 -0800 (PST)
Date: Mon, 4 Mar 2013 23:09:22 +0100
From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130304230922.20f6c05a@spider.haslach.nod.at>
In-Reply-To: <20130304210522.GA7783@localhost>
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
	<5133C900.9050300@sandeen.net>
	<20130303231905.0efd6d08@spider.haslach.nod.at>
	<5133D15A.9010600@sandeen.net>
	<20130303235341.7470085e@spider.haslach.nod.at>
	<5133D573.3050106@sandeen.net> <20130304004229.GK23616@dastard>
	<20130304210522.GA7783@localhost>
Mime-Version: 1.0
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
To: Joel Becker <jlbec@evilplan.org>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Am Mon, 4 Mar 2013 13:05:23 -0800
schrieb Joel Becker <jlbec@evilplan.org>:
> > Really, xfstests is not designed for testing cluster filesystems in
> > clustered environments. If we really want to support clustered
> > filesystems and cluster wide operations, then we need to think
> > about how to architect multi-host support into xfstests sanely.
> > Clustered filesystems are not the only people that could make use of
> > such functionality (NFS and CIFS come to mind).... ;)
> 
> I'm much happier with the "check for other cluster mounts" approach
> rather than avoiding fsck entirely.  We like xfstests in the local or
> single-node cases to behave exactly as one would expect.
> 
> We do run xfstests on multiple nodes in a cluster, but by hand and
> with our own cleanup.  Obviously support for automating that would be
> awesome :-)

Can you share your cleanup code?

Thanks,
//richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
