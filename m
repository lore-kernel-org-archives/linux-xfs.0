Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 864C77F3F
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 14:18:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74AD7304051
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 12:18:04 -0700 (PDT)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id MgDcyLsciKaoe6Ls for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 12:18:00 -0700 (PDT)
Message-ID: <5148B9E5.5000702@jan-o-sch.net>
Date: Tue, 19 Mar 2013 20:17:57 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add background noise to test 276 (btrfs backref
	resolving)
References: <1363710260-10225-1-git-send-email-list.btrfs@jan-o-sch.net>
	<51489BD6.6030504@sandeen.net>
In-Reply-To: <51489BD6.6030504@sandeen.net>
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
Cc: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com, xfs@oss.sgi.com

On 19.03.2013 18:09, Eric Sandeen wrote:
>> Furthermore, this increases two constants which make the test simply cycle a
>> few seconds longer, increasing the chance to hit on something suspicious in
>> case we broke something.
> 
> Normally we don't change existing tests lest new failures look like regressions
> when they aren't, but hey, "btrfs is an experimental filesystem" so maybe it's
> ok in this case.  ;)  At some point when things are settled down, we wouldn't
> want to make a change like this.  But for now it doesn't bother me.

(justification) I thought about adding this modification as a separate
test - and I have no strict objections against doing so. It's just that
I hate duplicating code and I couldn't think of a good way to share all
that code between two individual tests. Plus: We do need the new
version, because it shows backref walking in fact is currently broken,
while the old version would never fail where the new one wouldn't.

Thanks for taking a look!
-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
