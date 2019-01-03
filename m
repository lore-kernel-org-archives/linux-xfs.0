Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfACVv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 16:51:59 -0500
Date: Thu, 3 Jan 2019 13:51:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: allow '/' in attribute names
Message-ID: <20190103215153.GH20475@magnolia>
References: <1c673348-0244-89ff-5b3c-545ee3e458e4@redhat.com>
 <20190103212044.GO4205@dastard>
 <7e3b23a4-fdb3-a23f-4339-97bae0e4a620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3b23a4-fdb3-a23f-4339-97bae0e4a620@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 03, 2019 at 03:27:26PM -0600, Eric Sandeen wrote:
> On 1/3/19 3:20 PM, Dave Chinner wrote:
> > On Thu, Jan 03, 2019 at 01:15:56PM -0600, Eric Sandeen wrote:
> >> For some reason, since the earliest days of XFS, a '/' character
> >> in an extended attribute name has been treated as corruption by
> >> xfs_repair.  This despite nothing in other userspace tools or the
> >> kernel having this restriction.
> >>
> >> My best guess is that this was an unintentional leftover from
> >> common code between dirs & attrs in the "da" code, and there has
> >> never been a good reason for it.
> >>
> >> Since userspace and kernelspace allow such a name to be set,
> >> listed, and read, it seems wrong to flag it as corruption.
> >> So, make this test conditional on whether we're validating a name
> >> in a dir, as opposed to the name of an attr.
> > 
> > Sounds fair.
> > 
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >>
> >> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> >> index 1d04500..2f6f7ef 100644
> >> --- a/repair/attr_repair.c
> >> +++ b/repair/attr_repair.c
> >> @@ -292,11 +292,9 @@ process_shortform_attr(
> >>  			}
> >>  		}
> >>  
> >> -		/* namecheck checks for / and null terminated for file names.
> >> -		 * attributes names currently follow the same rules.
> >> -		*/
> >> +		/* namecheck checks for null chars in attr names. */
> >>  		if (namecheck((char *)&currententry->nameval[0],
> >> -						currententry->namelen))  {
> >> +						currententry->namelen, false)) {
> > 
> > Hmmmm. that's kinda messy. How about:
> > 
> > /* attr_namecheck checks for null chars in attr names. */
> > bool
> > attr_namecheck(
> > 	uint8_t	name,
> > 	int	length)
> > {
> > 	return namecheck((char *)name, length, false);
> > }
> 
> Ok, good idea.

Can you put the dir/attr name verifier function(s) into libxfs so I can
reuse it in scrub instead of opencoding the same in there?  Pretty
please? :D

--D

> -Eric
