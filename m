Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04C787F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 12:38:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAEEE304051
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:38:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aGBxpM2wTFZcsv3x for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 10:38:27 -0700 (PDT)
Message-ID: <51F6A891.7070608@sandeen.net>
Date: Mon, 29 Jul 2013 12:38:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/315: add one more sync and more output
References: <1375118463-29654-1-git-send-email-jbacik@fusionio.com>
	<51F6A6DA.3080102@redhat.com>
In-Reply-To: <51F6A6DA.3080102@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: jeff.liu@oracle.com, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On 7/29/13 12:31 PM, Eric Sandeen wrote:
> Honest question: does one more sync make this deterministic, or is it a best-effort, um, hack?

I'm not quite sure why even 1 sync is needed.  :(

I'm not sure what bug this is trying to test; if you need 2 syncs for global space stats to accurately reflect the fact that you chopped off the end of a block, maybe that's ... still a bug?

Or if it's just the big-hammer question of "does the truncated space *ever* get freed?" then maybe umount/remount/check would tell you that more definitively.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
