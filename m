Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36DE67F4C
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 19:50:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25CE4304039
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 17:50:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4L5LQp82DKagt9v6 for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 17:50:27 -0700 (PDT)
Date: Mon, 11 Mar 2013 11:50:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem corruption
Message-ID: <20130311005024.GC20565@dastard>
References: <CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	<5139D792.4090304@redhat.com> <513A350A.508@hardwarefreak.com>
	<20130309091152.GH23616@dastard>
	<513B84AD.2000603@hardwarefreak.com>
	<20130310224536.GK23616@dastard>
	<513D1D51.7010905@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513D1D51.7010905@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Julien FERRERO <jferrero06@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

On Sun, Mar 10, 2013 at 06:54:57PM -0500, Stan Hoeppner wrote:
> On 3/10/2013 5:45 PM, Dave Chinner wrote:
> >>  Does everyone remember the transitive property of equality from math
> >> class decades ago?  It states "If A=B and B=C then A=C".  Thus if
> >> barrier writes to the journal protect the journal, and the journal
> >> protects metadata, then barrier writes to the journal protect metadata.
> > 
> > Yup, but the devil is in the detail - we don't protect individual
> > metadata writes at all and that difference is significant enough to
> > comment on.... :P
> 
> Elaborate on this a bit, if you have time.  I was under the impression
> that all directory updates were journaled first.

That's correct - they are all journalled.

But journalling is done at the transactional level, not that of
individual metadata changes. IOWs, journalled changes do not
contain the same information as a metadata buffer write - they
contain both more and less information than a metadata buffer write.

They contain more information in that there is change atomicity
information in the journal information for recovery purposes. i.e.
how the individual change relates to changes in other related
metadata objects. This information is needed in the journal so that
log recovery knows to either apply all the changes in a checkpoint
or none of them if this journal checkpoint (or a previous one) is
incomplete.

They contain less information in that the changes to a metadata
object is stored as a diff in the journal rather than as a complete
copy of the object. This is done to reduce the amount of journal
space and memory required to track and store all of the changes in
the checkpoint.

Hence what is written to the journal is quite different to what is
written during metadata writeback in both contents ad method. It is
the atomicity information in the journal that we know got
synchronised to disk (via the FUA/cache flush) that enables us to
get away with being lazy writing back metadata buffers in any order
we please without needing FUA/cache flushes...

So, yes you are correct in that the journalling protects metadata.
However, the distinction I'm making is that the journal writes
contain different information and have different constraints
compared to individual metadata object writeback, and therefore are
not the "same thing" and do not require the same protection from
power loss/crash events...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
