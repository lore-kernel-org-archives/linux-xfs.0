Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q09E1SAV011099 for <xfs@oss.sgi.com>; Mon, 9 Jan 2012 08:01:28 -0600
Message-ID: <4F0AF335.5070905@sgi.com>
Date: Mon, 09 Jan 2012 08:01:25 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: use the full 32-bit generation number
References: <1325880565-20934-1-git-send-email-wkendall@sgi.com>
	<20120108005822.GA32313@davidb.org>
In-Reply-To: <20120108005822.GA32313@davidb.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: David Brown <davidb@davidb.org>
Cc: xfs@oss.sgi.com

On 01/07/2012 06:58 PM, David Brown wrote:
> On Fri, Jan 06, 2012 at 02:09:25PM -0600, Bill Kendall wrote:
>
>> This patch changes xfsdump to use the full 32-bit inode generation
>> number.
>> A change to part of the dump format (direnthdr_t) was required, so the
>> dump format version has been bumped to 3. xfsdump also required
>> changes to
>> its inode-to-generation cache. This map is not persistent though, so no
>> compatibility or version changes were required there.
>
> I suspect that this does fix the problem. Since the fix is in the
> dump, not just restore, I guess I'll just have to start with a fresh
> level 0 and see if the failure ever happens again upon restore.

That's right. If you need to recover files from the backup that has
issues, try applying only your level 1 backup and select just the
files that failed to restore.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
