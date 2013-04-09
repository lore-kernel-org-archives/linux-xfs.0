Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47F0D29E11
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 09:04:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35945304067
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 07:04:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jIhHSeObBNxkIgmz for
	<xfs@oss.sgi.com>; Tue, 09 Apr 2013 07:04:11 -0700 (PDT)
Date: Tue, 9 Apr 2013 11:03:59 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfstests should still make xfs as default?
Message-ID: <20130409140358.GA27522@andromeda.usersys.redhat.com>
References: <20130327203231.GA26739@andromeda.usersys.redhat.com>
	<20130408230733.GB17758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130408230733.GB17758@dastard>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 09, 2013 at 09:07:34AM +1000, Dave Chinner wrote:
> On Wed, Mar 27, 2013 at 05:32:32PM -0300, Carlos Maiolino wrote:
> > Hi, working on xfstests after its new directory structures I noticed we should
> > use now something like:
> > 
> > ./check xfs/<test>
> > 
> > to run some tests, IMHO this is not intuitive and I was working on a patch to
> > make us able to use something just like the old way:
> > 
> > ./check <test>
> 
> What do you do with duplicate test names?
> 
> The main reason that the interface changed was to keep the changes
> to the test harness down to a minimum as it was just moving tests
> around. All that code needs to be revisited to support arbitrary
> test names, so there wasn't much point in doing a massive rework
> only to have to rework it again...
> 
> But the question is: is the old way a sane way to specify tests in
> the brave new world? I'd much prefer that test specification is
> explict, and doesn't implicitly select tests. Indeed, if it
> implicitly selects tests (e.g. when there are duplicates it runs all
> duplicates) then we still need a method for running specific
> tests.....
> 
> Note that what you are seeing is how the $have_test_arg code
> processes the test name. It requires that you tell it the directory
> so it knows where to look for the specific test. You could make it
> look in each test directory like get_group_list()/get_all_tests() do
> so we don't need to specify a directory.
> 
> > But, since xfstests is becoming more generalist than xfs specific, I wonder if
> > we should still keep xfs as default.
> 
> The default is whatever filesystem is on the $TEST_DEV, and I don't
> see that changing. i.e. what we set FSTYP to is the default. Note
> that get_group_list() and get_all_tests() specifically include the
> FSTYP directory,
> 
Hi, this makes sense to me Dave, thanks to the explanation.

We have some documentation which says xfstests will run tests for a xfs
filesystem by default if no other fstype is specified, I'll change this into
documentation then.

Cheers,

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
