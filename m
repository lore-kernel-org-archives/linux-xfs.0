Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E4D47F50
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 15:24:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4B2FAC002
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 13:24:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DUGyYW7G00G8IsUE for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 13:24:33 -0800 (PST)
Message-ID: <5314F310.8080703@sandeen.net>
Date: Mon, 03 Mar 2014 15:24:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: rebuilt HW RAID60 array; XFS filesystem looks bad now
References: <5314EE97.3020004@uga.edu>
In-Reply-To: <5314EE97.3020004@uga.edu>
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
To: Paul Brunk <pbrunk@uga.edu>, xfs@oss.sgi.com

Hi Paul -

On 3/3/14, 3:05 PM, Paul Brunk wrote:
> Hi:

<snip story about very unhappy raid>

It sounds like things are badly scrambled.

> Is there anything I should try prior to xfs_repair -L?

The log failure is probably just the first error xfs encounters;
I imagine that after you zap the log, you'll find that everything
else is in equally bad shape.

You could _try_ an 

# xfs_metadump -o /dev/whatever fs.metadump
# xfs_mdrestore fs.metadump fs.img

and then try your various metadata salvage techniques on fs.img
(recreating as necessary with another xfs_mdrestore after failure)
as practice runs, but I'm guessing that xfs_metadump will fail
in equally spectacular ways.

Unless you can get your storage somehow reassembled properly, I doubt
that there's much xfs tools can do to help you.

-Eric

> I'm just trying to salvage whatever I can from this FS.  I'm aware it
> could be all gone.  Thanks.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
