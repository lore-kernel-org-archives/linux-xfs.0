Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C66C77F8A
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 08:07:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A45B9304075
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 06:07:07 -0800 (PST)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id d6g3CwL2QRXBJbiw for
	<xfs@oss.sgi.com>; Wed, 29 Jan 2014 06:07:02 -0800 (PST)
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <52E90998.5050805@sandeen.net>
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
	<52E90998.5050805@sandeen.net>
Date: Wed, 29 Jan 2014 14:07:01 +0000
Message-Id: <1391004421.4294.68.camel@montana.filmlight.ltd.uk>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sillero@torroja.dmt.upm.es, xfs@oss.sgi.com


On Wed, 2014-01-29 at 08:00 -0600, Eric Sandeen wrote:

> > The system is setup as follow:
> >         XFS 6.1
> 
> Is this some variant of RHEL6.1?  XFS doesn't have version numbers
> like that.  (Probably not IRIX 6.1?) :)

See xfs_sb.h - 

#define XFS_SB_MAGIC            0x58465342      /* 'XFSB' */
#define XFS_SB_VERSION_1        1               /* 5.3, 6.0.1, 6.1 */
#define XFS_SB_VERSION_2        2               /* 6.2 - attributes */
#define XFS_SB_VERSION_3        3               /* 6.2 - new inode
version */
#define XFS_SB_VERSION_4        4               /* 6.2+ - bitmask
version */


> 
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
