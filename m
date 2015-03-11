Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 771C97F54
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 09:44:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B9368F8059
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 07:44:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id csQhlHCSE88BLAhc for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2015 07:44:43 -0700 (PDT)
Message-ID: <550054D9.3010602@sandeen.net>
Date: Wed, 11 Mar 2015 10:44:41 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
References: <54FDFEDC.5090106@sandeen.net>	<1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>	<54FF2BBF.7060404@sandeen.net>
	<410959445.428221.1426083973347.JavaMail.zimbra@rvx.is>
In-Reply-To: <410959445.428221.1426083973347.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

On 3/11/15 10:26 AM, Rui Gomes wrote:
> Hello Eric,
> 
> Thank you for the quick reply yesterday, I got to try the new patched version today,
> and we have now a segmentation fault at a different stage of the repair  \o/ 
> Full output plus gdb traceback in the attachment.

If you have 4k sectors, you might need this patch from the list:

[PATCH] xfs: superblock buffers need to be sector sized

http://marc.info/?l=linux-xfs&m=142476196802097&w=2

as it's not merged yet.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
