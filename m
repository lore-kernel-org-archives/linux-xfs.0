Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A27E7F63
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 08:18:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6942304075
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 06:18:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id O0FIwouZHDf3mL4N for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 06:18:28 -0800 (PST)
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
	<52E90998.5050805@sandeen.net>
	<1391004421.4294.68.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1391004421.4294.68.camel@montana.filmlight.ltd.uk>
Message-Id: <43C533EA-A330-4BBE-9A38-31175E9EF1E4@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
Date: Wed, 29 Jan 2014 08:18:24 -0600
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: "sillero@torroja.dmt.upm.es" <sillero@torroja.dmt.upm.es>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Those are ancient comments from IRIX versions.  If he's using device mapper I suppose it is Linux after all. :)

Eric


> On Jan 29, 2014, at 8:07 AM, Roger Willcocks <roger@filmlight.ltd.uk> wrote:
> 
> 
> On Wed, 2014-01-29 at 08:00 -0600, Eric Sandeen wrote:
> 
>>> The system is setup as follow:
>>>        XFS 6.1
>> 
>> Is this some variant of RHEL6.1?  XFS doesn't have version numbers
>> like that.  (Probably not IRIX 6.1?) :)
> 
> See xfs_sb.h - 
> 
> #define XFS_SB_MAGIC            0x58465342      /* 'XFSB' */
> #define XFS_SB_VERSION_1        1               /* 5.3, 6.0.1, 6.1 */
> #define XFS_SB_VERSION_2        2               /* 6.2 - attributes */
> #define XFS_SB_VERSION_3        3               /* 6.2 - new inode
> version */
> #define XFS_SB_VERSION_4        4               /* 6.2+ - bitmask
> version */
> 
> 
> -- 
> Roger Willcocks <roger@filmlight.ltd.uk>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
