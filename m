Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9Hp9ZA133153 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 11:51:09 -0600
Message-ID: <509D42FC.8080204@sgi.com>
Date: Fri, 09 Nov 2012 11:53:00 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: NFS stalls when writing - linux 3.6.x
References: <50957087.6050008@xinu.at> <20121107190724.GD7421@fieldses.org>
	<509D2993.4050604@xinu.at> <20121109163658.GE6171@fieldses.org>
	<20121109172014.GT9783@sgi.com> <509D3C9A.6040209@xinu.at>
In-Reply-To: <509D3C9A.6040209@xinu.at>
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
To: Florian Pritz <bluewind@xinu.at>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On 11/09/12 11:25, Florian Pritz wrote:
> On 09.11.2012 18:20, Ben Myers wrote:
>> I took a brief look but there were no slam dunks.  This seems like it might be
>> a candidate:
>>
>> 8375f922 - xfs: re-enable xfsaild idle mode and fix associated races
>>
>> The sysrq-trigger information would definately be helpful.  Meanwhile I'll see
>> if I can reproduce the issue.
>
> No idea why it doesn't show up on gmane yet (the excerpt is from my mail
> to the list), but I've uploaded it here[1]. The link will be valid for
> 10 days.
>
> [1]: https://paste.xinu.at/koXRw/
>
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Thank-you for the task list. Could we get a dump of the hang?

  # echo c >/proc/sysrq-trigger

It requires kdump configured.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
