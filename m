Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F9FC54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD0D2080C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zn9ekTn0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgD0RH6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:07:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47890 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgD0RH5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:07:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RH2hB4059422;
        Mon, 27 Apr 2020 17:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=F5vNBlNks7+V9Ura3tnSVb4cLLVgSGwpdLcQf/JSqiA=;
 b=Zn9ekTn0SmcTlZf46/yiQzzhhQZdgWOuQnKHQxNqShYucibslWIk+nDIMrRPuHCcKddH
 71DwC6XZUJXnPQC6l0NPmMG2t1z0oY42uX+aU1KGHMZg+AXGUFmVS9N37+VBxeo/AKZ6
 NdR8rCLkOfsc6ZtqOb3VyVPVzgaM56qZ4ohZVecO6Z1cCsCNgw3sdryCXpopf7mJlbJR
 OCPxWWLbn1S2Up5/sBudphILCskESJgZbo8FzIZh/jfP1rD8Qm2W2FHgYqcMcfPqecBD
 BOZgKYDQA6BHVHMiKRVnr/Dyh6yBABYz6ejm4roLLdAESPVjAt49d2fgr5K68y/N7mK1 vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucftver-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:03:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RH1srY171074;
        Mon, 27 Apr 2020 17:03:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30mxwwkav3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:03:32 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RH3Vsx004695;
        Mon, 27 Apr 2020 17:03:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:03:31 -0700
Date:   Mon, 27 Apr 2020 10:03:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/fuzzy: don't attempt online scrubbing unless
 supported
Message-ID: <20200427170330.GO6742@magnolia>
References: <20200421113643.24224-1-ailiop@suse.com>
 <20200421153717.GY6742@magnolia>
 <20200424110330.GV1329@technoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424110330.GV1329@technoir>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 01:03:30PM +0200, Anthony Iliopoulos wrote:
> On Tue, Apr 21, 2020 at 08:37:17AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 21, 2020 at 01:36:42PM +0200, Anthony Iliopoulos wrote:
> > > Many xfs metadata fuzzing tests invoke xfs_scrub to detect online errors
> > > even when _scratch_xfs_fuzz_metadata is invoked with "offline". This
> > > causes those tests to fail with output mismatches on kernels that don't
> > > enable CONFIG_XFS_ONLINE_SCRUB. Bypass scrubbing when not supported.
> > > 
> > > Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> > > ---
> > >  common/fuzzy | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/common/fuzzy b/common/fuzzy
> > > index 988203b1..83ddc3e8 100644
> > > --- a/common/fuzzy
> > > +++ b/common/fuzzy
> > > @@ -238,7 +238,7 @@ __scratch_xfs_fuzz_field_test() {
> > >  	if [ $res -eq 0 ]; then
> > >  		# Try an online scrub unless we're fuzzing ag 0's sb,
> > >  		# which scrub doesn't know how to fix.
> > > -		if [ "${repair}" != "none" ]; then
> > > +		if _supports_xfs_scrub "${SCRATCH_MNT}" "${SCRATCH_DEV}"; then
> > 
> > Huh?
> > 
> > This changes the behavior of the repair=none fuzz tests, which mutate
> > filesystems and then write to them without running any checking tools
> > whatsoever to see if we can trip over the mutations with only regular
> > filesystem operations.  Whereas before, we'd skip xfs_scrub, now we
> > always run it if it's supported.
> 
> oops...right, we want to let the verifiers catch the errors here.
> 
> Speaking of which, I've been staring at the scripts but it's not clear
> to me how the repair=none fuzz tests are expected to function. Many of
> those tests corrupt AG metadata headers (e.g. the AGI lsn), which means
> mount bails out with an error. But the golden output doesn't account for
> that, so those tests will fail (e.g. xfs/456).

None of the dangerous_fuzz* tests have golden output.  I've thought
about posting the ones that are in my dev tree, but there's probably
not much point until I/we finish fixing the things that repair misses.
Ditto with scrub.

TBH I wrote all these field fuzzers solely as a means to fuzz things
systematically, and didn't think too hard about using them as regression
tests.  Back when I introduced the dangerous_norepair tests, it was
success enough if the kernel didn't crash.  I /think/ we've tightened
things up enough that it's time to move on to more careful checking for
runtime errors.

> Further, for things like inode metadata fuzzing where the fs is usually
> mountable, the tests will always succeed irrespective of the verifiers
> firing or not (e.g. xfs/465).
> 
> I'd assume all those repair=none tests would need to check dmesg for
> metadata corruptions, so something like:
> 
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -254,3 +254,3 @@ __scratch_xfs_fuzz_field_test() {
>  		__scratch_xfs_fuzz_unmount
> -	else
> +	elif [ "${repair}" != "none" ]; then
>  		(>&2 echo "re-mount failed ($res) with ${field} = ${fuzzverb}.")

Hmm, seems reasonable.  The _scratch_fuzz_modify helper probably needs
to be modified to complain if the fs writes actually succeed.

> --- a/tests/xfs/456
> +++ b/tests/xfs/456
> @@ -43,2 +43,5 @@ echo "Done fuzzing AGI"
> 
> +_check_dmesg_for "Metadata corruption detected" || \
> +	_fail "Missing metadata corruption messages!"

I'd put this at the end of __scratch_xfs_fuzz_field_test, since there
are dozens of tests that use this function, not just xfs/456.

The long term goal is to make all the corruption bailouts report
themselves to the online health system so that userspace can query the
filesystem status (via xfs_spaceman) without having to scrape dmesg.

--D

> +
>  # success, all done
> 
> If this makes sense, I'll send a separate patch to address it, and fix
> all repair=none tests as above.
> 
> > The open-coded repair conditionals scattered through this funciton
> > probably ought to be refactored into helpers, e.g.
> > 
> > __fuzz_want_scrub_check() {
> > 	local repair="$1"
> > 	local field="$2"
> > 
> > 	test "${repair}" != "none" && \
> > 		_supports_xfs_scrub "${SCRATCH_MNT}" "${SCRATCH_DEV}" && \
> > 		[ "${field}" != "sb 0" ]
> > }
> > 
> > if [ $res -eq 0 ]; then
> > 	# Try an online scrub...
> > 	if __fuzz_want_scrub_check "${repair}" "${field}"; then
> > 		_scratch_scrub -n -a 1 -e continue 2>&1
> > 		...
> 
> Will do that and send a v2, thanks for the review!
