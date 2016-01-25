Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C29EC7CA1
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:04:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D753AC002
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 08:04:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xVhW1pLy8I0csfBF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 08:04:34 -0800 (PST)
Subject: Re: [PATCH 0/7 V3] quota: add new quotactl Q_GETNEXTQUOTA
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
	<20160125150710.GN24938@quack.suse.cz>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56A64790.9090100@redhat.com>
Date: Mon, 25 Jan 2016 10:04:32 -0600
MIME-Version: 1.0
In-Reply-To: <20160125150710.GN24938@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 1/25/16 9:07 AM, Jan Kara wrote:
> On Fri 22-01-16 12:25:29, Eric Sandeen wrote:

...

> So I've taken patch 1/7 into my tree since that is completely independent.
> Patches 2/7 and 3/7 look mostly good to me (except for that small omission
> in 3/7) so I can take them to my tree as well. Once I'll finish testing
> some UDF changes I have pending I'll push the tree to:

Jan, thanks for catching & fixing those issues.

> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next
> 
> and Dave can pull from there to have a basis for XFS patches. I want to
> implement Q_GETNEXTQUOTA for VFS quota formats as well and those will go
> through my tree so that's why I want the interface changes go via my tree.

Makes sense to me.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
