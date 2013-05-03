Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEA947F55
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 08:06:18 -0500 (CDT)
Message-ID: <5183B652.8020300@sgi.com>
Date: Fri, 3 May 2013 08:06:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/276 - stop all fsstress before exiting
References: <517A10B1.7040107@redhat.com> <517A3C49.9090703@jan-o-sch.net>
	<7DC41D7F-396D-4769-B573-816E80372456@redhat.com>
In-Reply-To: <7DC41D7F-396D-4769-B573-816E80372456@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <esandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Jan Schmidt <list.btrfs@jan-o-sch.net>, xfs-oss <xfs@oss.sgi.com>

On 04/26/2013 08:10 AM, Eric Sandeen wrote:
> On Apr 26, 2013, at 3:35 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
>
>> On Fri, April 26, 2013 at 07:29 (+0200), Eric Sandeen wrote:
>>> Tests after 276 were failing because the background fsstress
>>> hadn't quit prior to exit, devices couldn't be unmounted, etc.
>>
>> I don't see how that would happen. Any further insight?
>>
> Yes, sorry for not including it.  The parent process was killed, but the fsstress processes just got reparented to init.
>
> I tried for a while to use pkill to knock them of first but this seems simpler, actually.
>
> Eric
>

Jan, with Eric's explanation, may I put your Reviewed-by: on this patch?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
