Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QIBAF9236080 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 13:11:10 -0500
Message-ID: <50634585.3030400@sgi.com>
Date: Wed, 26 Sep 2012 13:12:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: Set a clean output in case of invalid inode size
References: <1334609816-8473-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1334609816-8473-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 04/16/12 15:56, Carlos Maiolino wrote:
> Remove an unnecessary usage() call after a mkfs failure due an invalid inode
> size.
> A call to usage() at this point confuses the output message which may cause the
> user to think it used wrong arguments to mkfs, instead of an invalid inode size.
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---


Found that this patch was reviewed but not committed.

Committed to git://oss.sgi.com/xfs/cmds/xfsprogs.git, master branch.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
