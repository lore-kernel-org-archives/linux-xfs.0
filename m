Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 808117F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 16:39:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 719F98F8040
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 14:39:46 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2SN3gKPQgDpH6T8g for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 14:39:43 -0800 (PST)
Date: Wed, 2 Dec 2015 09:39:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question on how to submit changed code
Message-ID: <20151201223929.GC19199@dastard>
References: <105716A9A63E8A4C9CB26A0F29E203DCF40BE069@usbpx2pmxmbx12>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <105716A9A63E8A4C9CB26A0F29E203DCF40BE069@usbpx2pmxmbx12>
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
To: "Epp, Mike" <MEpp@KrollOntrack.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Dec 01, 2015 at 03:16:11PM +0000, Epp, Mike wrote:
> I have changed code in libxfs and repair projects for xfsprogs.  I
> don't view the changes as desired for ongoing deployment, as they
> allowed scanning of active volumes and bring the chance of false
> errors.  To stay compliant with GNU GPL though we must publish the
> code.  What are the steps I need to follow to publish the changes?

Many options, but you should really be asking you company's legal
counsel this question.

>From my perspective, either of these would work:

	- add a page to your company's website with a link from the
	  home page that contains the tarballs of modified packages.
	- put the modified source code up in a repository on github
	  (or similar) and include a link from the website
	- send patches to an archived mailing list whenever you
	  change the code, and place a link to the archive on your
	  website home page.

> Do I need to publish just the source files I changed, the entire
> projects I changes, or all of xfsprogs?

-> legal counsel

The license spells out what is necessary. All of the above are valid
interpretations....

> Mike Epp, Senior Software Engineer Kroll Ontrack |  9023 Columbine
> Road, Eden Prairie, MN 55347
> mepp@krollontrack.com<mailto:mepp@krollontrack.com>
> www.krollontrack.com<http://www.krollontrack.com/ohttp:/www.krollontrack.com/>
> This communication contains information that is confidential,
> proprietary in nature, and may also be attorney-client privileged
> and/or work product privileged. It is for the exclusive use of the
> intended recipient(s).

[snip]

And any code you send to the mailing list must have a valid
signed-off-by and not have a bunch of restrictive legal mumbo jumbo
on the end of it....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
