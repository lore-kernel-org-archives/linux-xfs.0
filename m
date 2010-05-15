Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4FH67oo108748 for <xfs@oss.sgi.com>; Sat, 15 May 2010 12:06:07 -0500
Received: from mail001.aei.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21027129479D
	for <xfs@oss.sgi.com>; Sat, 15 May 2010 10:09:08 -0700 (PDT)
Received: from mail001.aei.ca (mail001.aei.ca [206.123.6.130]) by cuda.sgi.com
	with ESMTP id XWYA3juORITMUaEd for <xfs@oss.sgi.com>;
	Sat, 15 May 2010 10:09:08 -0700 (PDT)
From: Ed Tomlinson <edt@aei.ca>
Subject: Re: Defrag in shrinkers
Date: Sat, 15 May 2010 13:08:17 -0400
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
	<alpine.DEB.2.00.1005141244380.9466@router.home>
	<87y6fmmdak.fsf@basil.nowhere.org>
In-Reply-To: <87y6fmmdak.fsf@basil.nowhere.org>
MIME-Version: 1.0
Message-Id: <201005151308.18090.edt@aei.ca>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>, linux-fsdevel@vger.kernel.org, Christoph Lameter <cl@linux.com>

On Friday 14 May 2010 16:36:03 Andi Kleen wrote:
> Christoph Lameter <cl@linux.com> writes:
> 
> > Would it also be possible to add some defragmentation logic when you
> > revise the shrinkers? Here is a prototype patch that would allow you to
> > determine the other objects sitting in the same page as a given object.
> >
> > With that I hope that you have enough information to determine if its
> > worth to evict the other objects as well to reclaim the slab page.
> 
> I like the idea, it would be useful for the hwpoison code too,
> when it tries to clean a page.

If this is done generally we probably want to retune the 'pressure' put on the slab.  The
whole reason for the callbacks was to keep the 'pressure on the slab proportional to the
memory pressure (scan rate).  

Ed Tomlinson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
