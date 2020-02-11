Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C6DC3B187
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 15:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A6D215A4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 15:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="COX+vFoM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBKPUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 10:20:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgBKPUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 10:20:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BFILWU116818;
        Tue, 11 Feb 2020 15:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qcq2S/zOtUIPhfHPcagj2neEPKPDdYgZr+XEF7QMmEQ=;
 b=COX+vFoMmnA3TUzM/bZmJxh7P11+QAf3UE8JGcvfvnrZhhq/F0gCNkWkYY8JoNnB3ANz
 MQiPJL9Rs46+e5Tmo6CitBKPzLC2wh9MhfKfAIuuxUZ9u5aVQPT19kJqbMdmB3OX4Bw8
 ngIyYzSLHI2hIglY8LxNIAauRFOQ7rY0mIWjjxj4q3OL04+UFcrjSraI202klx/2/4R8
 XfXc8a3LT6RRgR6maN5/CsHknYcy/N0k9pr50Oa6egTBH3UYIHR/OC9CVRqA8A23oPTS
 c+cPeFwn+pi2xNwG3rgNxbKP0AHiBILzsW2S/nhj9cg0dnSYWHZyB7+zGb1N88w6Zjaz Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y2jx6484t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 15:20:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BFI9VD169933;
        Tue, 11 Feb 2020 15:20:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y26hv41am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 15:20:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01BFKVsW001693;
        Tue, 11 Feb 2020 15:20:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Feb 2020 07:20:30 -0800
Date:   Tue, 11 Feb 2020 07:20:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] generic/402: skip test if xfs_io can't parse the
 date value
Message-ID: <20200211152030.GL6870@magnolia>
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
 <158086092087.1989378.18220785148122680849.stgit@magnolia>
 <20200209152954.GE2697@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209152954.GE2697@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002110113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 09, 2020 at 11:29:54PM +0800, Eryu Guan wrote:
> On Tue, Feb 04, 2020 at 04:02:00PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If xfs_io's utimes command cannot interpret the arguments that are given
> > to it, it will print out "Bad value for [am]time".  Detect when this
> > happens and drop the file out of the test entirely.
> > 
> > This is particularly noticeable on 32-bit platforms and the largest
> > timestamp seconds supported by the filesystem is INT_MAX.  In this case,
> > the maximum value we can cram into tv_sec is INT_MAX, and there is no
> > way to actually test setting a timestamp of INT_MAX + 1 to test the
> > clamping.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/402 |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/generic/402 b/tests/generic/402
> > index 2a34d127..32988866 100755
> > --- a/tests/generic/402
> > +++ b/tests/generic/402
> > @@ -63,10 +63,19 @@ run_test_individual()
> >  	# check if the time needs update
> >  	if [ $update_time -eq 1 ]; then
> >  		echo "Updating file: $file to timestamp $timestamp"  >> $seqres.full
> > -		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file
> > +		$XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file >> $tmp.utimes 2>&1
> 
> Agree with Amir here, ">" whould be better, instead of appending.

Fixed.

> > +		cat $tmp.utimes >> $seqres.full
> > +		if grep -q "Bad value" "$tmp.utimes"; then
> 
> Echo a message to $seqres.full about this test being skipped?

Fixed.

> > +			rm -f $file $tmp.utimes
> > +			return
> > +		fi
> > +		cat $tmp.utimes
> > +		rm $tmp.utimes
> >  		if [ $? -ne 0 ]; then
> 
> So here we test the result of "rm $tmp.utimes"? I guess that's always a
> pass.

Err, oops, I'll save the value of $? from the xfs_io command.

> >  			echo "Failed to update times on $file" | tee -a $seqres.full
> >  		fi
> > +	else
> > +		test -f $file || return
> 
> Same here, better to be verbose about skipping test.

ok.

--D

> Thanks,
> Eryu
> 
> >  	fi
> >  
> >  	tsclamp=$((timestamp<tsmin?tsmin:timestamp>tsmax?tsmax:timestamp))
> > 
