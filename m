Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFCBC7F72
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 20:25:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98ED7AC003
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 18:25:55 -0700 (PDT)
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.10]) by
	cuda.sgi.com with ESMTP id wwQgJAEaHokVggU4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 18:25:51 -0700 (PDT)
In-Reply-To: <20140531011450.GJ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-12-git-send-email-arnd@arndb.de>
	<20140531003712.GH14410@dastard> <5389252A.5050503@zytor.com>
	<20140531011450.GJ14410@dastard>
MIME-Version: 1.0
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 30 May 2014 18:22:55 -0700
Message-ID: <c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com>
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
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

No, not a strawman.  Replace with Jan 26, 2038 and you have the same situation.

On May 30, 2014 6:14:50 PM PDT, Dave Chinner <david@fromorbit.com> wrote:
>On Fri, May 30, 2014 at 05:41:14PM -0700, H. Peter Anvin wrote:
>> On 05/30/2014 05:37 PM, Dave Chinner wrote:
>> > 
>> > IOWs, the filesystem has to be able to reject any attempt to set a
>> > timestamp that is can't represent on disk otherwise Bad Stuff will
>> > happen,
>> 
>> Actually it is questionable if it is worse to reject a timestamp or
>just
>> let it wrap.  Rejecting a valid timestamp is a bit like "You don't
>> exist, go away."
>
>I think having the new systems calls being able to
>return EINVAL if the value cannot be stored permanently on disk
>correctly is the right thing to do. Having it silently mangled
>by the filesystem and returning "everything is just fine, trust me"
>is close to the worst solution I can think of. That's exactly what
>leads to overflow bugs occurring....
>
>> > and filesystems have to be able to specify in their on
>> > disk format what timestamp encoding is being used. The solution
>will
>> > be different for every filesystem that needs to support time beyond
>> > 2038.
>> 
>> Actually the cutoff can be really different for each filesystem, not
>> necessarily 2038.  However, I maintain the above still holds.
>
>Sure, but all filesystems are supposed to handle at least the
>current unix epoch.
>
>> Consider a filesystem that kept timestamps in YYMMDDHHMMSS format. 
>What
>> would you have expected such a filesystem to do on Jan 1, 2000?
>
>Strawman.
>
>We don't need to cater for fundamentally broken designs that can't
>even handle the current unix epoch correctly. If such filesystems
>exist, then they can simple say "original unix epoch support only"
>and do whatever crap they are doing right now.
>
>Cheers,
>
>Dave.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
