Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 880747F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 13:25:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3AB6B304051
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 11:25:29 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id bvUNhmTtJuqHCGuc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 11:25:28 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AAF097C0645
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 12:25:27 -0600 (MDT)
Date: Mon, 29 Jul 2013 14:25:25 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests: generic/315: add one more sync and more output
Message-ID: <20130729182525.GD24583@localhost.localdomain>
References: <1375118463-29654-1-git-send-email-jbacik@fusionio.com>
	<51F6A6DA.3080102@redhat.com> <51F6A891.7070608@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F6A891.7070608@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, jeff.liu@oracle.com

On Mon, Jul 29, 2013 at 12:38:25PM -0500, Eric Sandeen wrote:
> On 7/29/13 12:31 PM, Eric Sandeen wrote:
> > Honest question: does one more sync make this deterministic, or is it a best-effort, um, hack?
> 
> I'm not quite sure why even 1 sync is needed.  :(
> 

Because of COW, we won't free up the data space until the transaction commits
because it is pinned, so doing the truncate and then immediately doing df will
show no difference.

> I'm not sure what bug this is trying to test; if you need 2 syncs for global space stats to accurately reflect the fact that you chopped off the end of a block, maybe that's ... still a bug?
> 

No, it's just COW for you, in this case we do our sync, stuff gets updated and
some metadata is cow'ed for once reason or another and now df doesn't quite
match up (in my case it was off by like 9 blocks), doing a second sync clears
these out and then df's match.

> Or if it's just the big-hammer question of "does the truncated space *ever* get freed?" then maybe umount/remount/check would tell you that more definitively.

Yeah but I think I'll do what you suggested on IRC and just use _within_range.
Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
