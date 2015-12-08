Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5A1497F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 16:14:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BF5C8F8037
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 14:14:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GXjUBElQeOeS8ZYe for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 14:14:16 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 614D963BEEB9
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 16:14:16 -0600 (CST)
Subject: Re: Metadata corruption detected at xfs_attr3_leaf_write_verify /
	Internal error xfs_attr3_leaf_write_verify
References: <5666F521.5060602@3qmedien.net> <20151208205759.GE19802@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56675637.2050608@sandeen.net>
Date: Tue, 8 Dec 2015 16:14:15 -0600
MIME-Version: 1.0
In-Reply-To: <20151208205759.GE19802@dastard>
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
To: xfs@oss.sgi.com



On 12/8/15 2:57 PM, Dave Chinner wrote:
> On Tue, Dec 08, 2015 at 04:20:01PM +0100, Dietmar Putz wrote:
>> similar reports are existing :
>> http://oss.sgi.com/archives/xfs/2015-11/msg00459.html
>> https://bugs.launchpad.net/ubuntu/+source/linux-lts-trusty/+bug/1468039
> 
> Following a  couple of clicky links in that bug leads to:
> 
> http://oss.sgi.com/archives/xfs/2015-06/msg00457.html
> 
> in which I comment:
> 
> | Probably fixed by commit c88547a ("xfs: fix directory hash ordering
> | bug"), which also affected attributes in leaf format.
> 
> Hence this was probably fixed in 3.15 and pushed back to 3.13.11i
> via th eupstream stable kernel process. I have no idea if the ubuntu
> maintainers have added that fix to their kernel...

But:

> After upgrade to kernel 3.19.0-39 the error message turns from "Internal error xfs_attr3_leaf_write_verify...." to 
> "Metadata corruption detected at xfs_attr3_leaf_write_verify..." as shown below for gluster-ger-ber-11-int.

and that's 3.19 ...?  (and repair found nothing on-disk?)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
