Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FE8B7F37
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 08:36:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81E6130404E
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 06:36:52 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id FOqTfYLmnbmGWtHu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 06:36:51 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2F9787C0417
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 07:36:50 -0600 (MDT)
Date: Thu, 19 Sep 2013 09:36:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests: introduce _filter_backtick
Message-ID: <20130919133647.GB1615@localhost.localdomain>
References: <1379536166-19232-1-git-send-email-jbacik@fusionio.com>
	<20130918211325.GB4330@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130918211325.GB4330@dastard>
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
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Thu, Sep 19, 2013 at 07:13:25AM +1000, Dave Chinner wrote:
> On Wed, Sep 18, 2013 at 04:29:26PM -0400, Josef Bacik wrote:
> > Apparently the GNU guys decided to change their error output from something like
> > 
> > Error `Error message'
> > 
> > To
> > 
> > Error 'Error message'
> > 
> > So to fix this I've introduced _filter_backtick which will change any ` to ' and
> > then changed the output of the tests that were failing for me because of this
> > output.  I tested this on a new box that has the new output and an old box which
> > has the old output and it appears to fix the issue.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> That's just leaving a landmine behind, and it doesn't catch all the
> tests that need updating. This approach was floated here:
> 
> http://oss.sgi.com/archives/xfs/2013-05/msg00312.html
> 
> And my response was to add a global filter to the .check file so it
> doesn't leave a landmine. Indeed, I have a local version on tomas'
> patch that I modified in May does just that:
> 
> --- a/check
> +++ b/check
> @@ -477,6 +477,10 @@ do
>                 echo " - no qualified output"
>                 err=true
>             else
> +
> +               # coreutils 2.16+ changed quote formats in error messages from
> +               # `foo' to 'foo'. Filter old versions to match the new version.
> +               sed -i "s/\`/\'/g" $tmp.out
>                 if diff $seq.out $tmp.out >/dev/null 2>&1
>                 then
>                     if $err
> 
> I also discovered that for some reason LANG=C is not sufficient for
> all cases to make the quoting behaviour consistent. i.e. I
> needed to set LC_ALL=C so that it didn't use weird UTF-8 encodings
> for the quotes instead of a simple backtick.
> 
> Full patch below.

Excellent, what is holding this patch up then if it was proposed in May and you
are ok with it?  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
