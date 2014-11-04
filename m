Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FCA67F4E
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 01:40:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CFCE8F8039
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 23:40:27 -0800 (PST)
Received: from mail.emea.novell.com (mail.emea.novell.com [130.57.118.101]) by
	cuda.sgi.com with ESMTP id IBSeGZgaQOBzWzcA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 23:40:25 -0800 (PST)
Message-Id: <545890F40200007800044A31@mail.emea.novell.com>
Date: Tue, 04 Nov 2014 07:40:20 +0000
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: your patch "mm: Remove false WARN_ON from
	pagecache_isize_extended()"
References: <5457BE390200007800044838@mail.emea.novell.com>
	<20141103221849.GB23575@dastard>
In-Reply-To: <20141103221849.GB23575@dastard>
Mime-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

>>> On 03.11.14 at 23:18, <david@fromorbit.com> wrote:
> On Mon, Nov 03, 2014 at 04:41:13PM +0000, Jan Beulich wrote:
>> having run into that warning too, I looked into it a little, and now
>> having found that patch am pretty uncertain: Both truncate_setsize()
>> and pagecache_isize_extended() document that they want to be
>> called with i_mutex held, so removing the WARN_ON() alone seems
>> either incomplete or wrong. What I found to work without violating
>> this documented requirement is the patch below.
> 
> Or, just perhaps, the comments are wrong....

Right - that's what I was suggesting with the option of the patch
being incomplete (rather than just removing the WARN_ON() it
should also remove the respective comments then).

Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
