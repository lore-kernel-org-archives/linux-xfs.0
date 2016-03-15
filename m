Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 955A47CA0
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 22:31:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62AC930404E
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 20:31:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fVraIi2BnIIlqSNF for <xfs@oss.sgi.com>;
	Mon, 14 Mar 2016 20:30:56 -0700 (PDT)
Date: Tue, 15 Mar 2016 14:30:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFSTESTS v4 0/4] Richacl tests
Message-ID: <20160315033040.GD30721@dastard>
References: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
	<20160314222433.GC11812@dastard>
	<CAHc6FU4MqOqfzEeig-73An-9tQEgZE2BtWpjrs6ZPWB26x9AxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU4MqOqfzEeig-73An-9tQEgZE2BtWpjrs6ZPWB26x9AxQ@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: fstests@vger.kernel.org, XFS Developers <xfs@oss.sgi.com>

On Tue, Mar 15, 2016 at 12:23:57AM +0100, Andreas Gruenbacher wrote:
> On Mon, Mar 14, 2016 at 11:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Mar 09, 2016 at 01:06:34PM +0100, Andreas Gruenbacher wrote:
> >> Hello,
> >>
> >> here is a new version of the richacl tests.
> >
> > xfstests patches need to be sent to fstests@vger.kernel.org (added
> > to CC list), not xfs@oss.sgi.com.
> 
> Sorry for that.
> 
> >> According to feedback from the
> >> previous posting (http://oss.sgi.com/archives/xfs/2015-12/msg00316.html), each
> >> of the richacl tests is not run separately, on a new scratch filesystem.
> >
> > Oh, my. So, you've taken this one comment:
> >
> >         "The rule of thumb is that there should be one xfs test per
> >         individual regression test. You've got at least 10 separate
> >         regression tests there, so there should be at least 10
> >         xfstests.  They should not be aggregated into a single test
> >         - if you need to run them all at once, then that is what the
> >         richacl test group is for..."
> >
> > And then *implemented your own execution infrastructure* so that the
> > tests are /listed/ as separate tests in a group file but you still
> > /run them/ as one test?
> >
> > I'm almost lost for words.
> 
> What? Each test runs separately; not sure what makes you think otherwise.

You added test generic/338, which is *not included in the group
file* and so is not run by the test harness. then you added
tests generic/339-348, which have a name suffix that matches the
script they are supposed to run located in the richacl/ directory.

tests generic/339-348 do one thing: they execute generic/338,
which then looks at the calling program name (e.g. 339-apply-masks)
strips out the test number to get the script it's supposed to run.
then it runs $here/richacl/apply-masks, captures all the
output and only if the test fails (based on the return value of
the script being run) does it dump the output of the test.


If I renumber tests on commit (which I do regularly), this
magical "run test generic/338" mechanism breaks completely. It's
fragile, unmaintainable and *completely unnecessary*.

> I've said again and again that maintaining one set of richacl tests in
> xfstests and another in the richacl package is going to really
> painful, and that because of that, I'm trying to find a way of using
> the same test scripts in both places. That message obviously didn't
> get through at all though. That is just sad.

Yes, I fully understand that's what you are trying to do. I've
already explained to you why your approached doesn't work for
xfstests, which Eric has further explained in his response.

Once we add a test to xfstests, the author *loses control* of the
test. Nobody "owns" a set of tests - anyone can modify them and we
expect that *everyone* will modify them. e.g. if someone is changing
some generic infrastructure, we don't expect them to have to
understand that there are these magical richacl tests that you can't
move or filter or change in the same way all the other hundreds of
tests can be changed. All the tests need to look the same, run the
same way, and be structured in the same way. Otherwise we are simply
setting ourselve up with a long term maintenance nightmare.

If you really need to keep an identical copy of the tests somewhere
else, then make the xfstests versions the master copy and write your
own harness wrapper around the outside of those scripts. Keeping
tests in standard format in xfstests is far more important to me
than whether they get kept in sync with some other external
package...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
