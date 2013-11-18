Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3743A29E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 16:45:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD28BAC004
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 14:45:44 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JQ0ghYEfWuPDEInk for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 14:45:43 -0800 (PST)
Message-ID: <528A987E.2040103@sandeen.net>
Date: Mon, 18 Nov 2013 16:45:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] xfs: open code inc_inode_iversion when logging an
	inode
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>	<1383280040-21979-3-git-send-email-david@fromorbit.com>	<528A8C90.3010401@sandeen.net>
	<20131118222826.GJ1935@sgi.com>
In-Reply-To: <20131118222826.GJ1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 11/18/13, 4:28 PM, Ben Myers wrote:
> On Mon, Nov 18, 2013 at 03:54:24PM -0600, Eric Sandeen wrote:

<snip>

>> Well, ok.  Maybe worth a note about why the unlocked read is 99.9999% ok...
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Ah, sorry Eric, I didn't realize you were still reviewing this guy.  I pulled
> him in a bit earlier in the day.

No worries.  I'm very slow.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
