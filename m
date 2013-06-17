Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E60337F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 10:19:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D4BCAC003
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 08:19:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0K1JUDi7BXxo3ZLW for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 08:18:59 -0700 (PDT)
Message-ID: <51BF28E3.6020102@sandeen.net>
Date: Mon, 17 Jun 2013 10:18:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: linux software raid5 on lvm: sunit/swidth required?
References: <57FC0B2322184044812B39B9440D8AF662898079AA@MBX1.vi.corp>
In-Reply-To: <57FC0B2322184044812B39B9440D8AF662898079AA@MBX1.vi.corp>
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
To: Thomas Molszich <Thomas.Molszich@vanderlande.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 6/17/13 10:06 AM, Thomas Molszich wrote:
> Hello all,
> 
>  
> 
> At present, does one still need to calculate and pass the sunit/swidth to mkfs.xfs or does xfs calculate
> 
> All this on its own?
> 
> Xfsprogs 3.1.7, linked against libblkid, kernel 3.2.48 (Ubuntu 12.04 LTS), 6x3000GB Hitachi 4k sectors
> 
> with 512b emulation, partitions and lvm 4k aligned already.

You've not provided much info, but lvm does export stripe geometry if present, and mkfs.xfs will pick it up from lvm.

run mkfs.xfs and it'll tell you what it used for stripe geometry if any, and you'll know if it's right.  :)

-Eric
 
> 
> If manual calculation is still required, where can I read up on that?
> 
>  
> 
> With kind regards
> 
>  
> 
> Thomas Molszich
> 
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
