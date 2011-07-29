Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TDgKm5046527 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 08:42:20 -0500
Received: from mail-pz0-f43.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D0D0A38F0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 06:42:19 -0700 (PDT)
Received: from mail-pz0-f43.google.com (mail-pz0-f43.google.com
	[209.85.210.43]) by cuda.sgi.com with ESMTP id m97CoWOTOlXmtM6j
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 06:42:19 -0700 (PDT)
Received: by pzk1 with SMTP id 1so5065793pzk.2
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 06:42:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110729095005.GH1843@barrios-desktop>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<20110727161821.GA1738@barrios-desktop> <20110728113852.GN3010@suse.de>
	<20110729094816.GG1843@barrios-desktop>
	<20110729095005.GH1843@barrios-desktop>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 29 Jul 2011 09:41:59 -0400
Message-ID: <CAObL_7Fnc820gFvFxZa3iHUzkKaZaMy9o7LAN7z8mk8_zUxkrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Reduce filesystem writeback from page reclaim v2
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Fri, Jul 29, 2011 at 5:50 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> Sorry for missing Ccing.
>
> On Fri, Jul 29, 2011 at 06:48:16PM +0900, Minchan Kim wrote:
>> On Thu, Jul 28, 2011 at 12:38:52PM +0100, Mel Gorman wrote:
>> > On Thu, Jul 28, 2011 at 01:18:21AM +0900, Minchan Kim wrote:
>> > > On Thu, Jul 21, 2011 at 05:28:42PM +0100, Mel Gorman wrote:
>> > > > Note how preventing kswapd reclaiming dirty pages pushes up its CPU
>>
>> <snip>
>>
>> > > > usage as it scans more pages but it does not get excessive due to
>> > > > the throttling.
>> > >
>> > > Good to hear.
>> > > The concern of this patchset was early OOM kill with too many scanning.
>> > > I can throw such concern out from now on.
>> > >
>> >
>> > At least, I haven't been able to trigger a premature OOM.
>>
>> AFAIR, Andrew had a premature OOM problem[1] but I couldn't track down at that time.
>> I think this patch series might solve his problem. Although it doesn't, it should not accelerate
>> his problem, at least.
>>
>> Andrew, Could you test this patchset?

Gladly, but not until Wednesday most likely.  I'm defending my thesis
on Monday :)

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
