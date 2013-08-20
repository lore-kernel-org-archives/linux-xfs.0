Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AFC027F4E
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 15:46:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D7F38F8039
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 13:46:48 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	XV2Ve4yu8FoJFSeu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 13:46:46 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure after merge of the final tree
Date: Tue, 20 Aug 2013 22:46:30 +0200
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130820120702.000b044e@oracle.com>
In-Reply-To: <20130820120702.000b044e@oracle.com>
MIME-Version: 1.0
Message-Id: <201308202246.30869.arnd@arndb.de>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>, linuxppc-dev@lists.ozlabs.org, Jeremy Kerr <jk@ozlabs.org>

On Tuesday 20 August 2013, Dwight Engen wrote:
> diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
> index f390042..90fb308 100644
> --- a/arch/powerpc/platforms/cell/spufs/inode.c
> +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> @@ -620,12 +620,12 @@ spufs_parse_options(struct super_block *sb, char *options, struct inode *root)
>                 case Opt_uid:
>                         if (match_int(&args[0], &option))
>                                 return 0;
> -                       root->i_uid = option;
> +                       root->i_uid = make_kuid(&init_user_ns, option);
>                         break;
>                 case Opt_gid:
>                         if (match_int(&args[0], &option))
>                                 return 0;
> -                       root->i_gid = option;
> +                       root->i_gid = make_kgid(&init_user_ns, option);
>                         break;
>                 case Opt_mode:
>                         if (match_octal(&args[0], &option))

Doesn't this mean the uid/gid is taken from the initial namespace rather than
from the namespace of the 'mount' process calling this? I think the logical
choice would be to have the UID be the one that gets passed here in the caller's
namespace.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
