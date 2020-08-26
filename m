Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF119C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC6CE20707
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t0JcjHIa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHZPPM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 11:15:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgHZPPL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 11:15:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QFAAPR071227;
        Wed, 26 Aug 2020 15:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4hSNaUwV/qrzsrFnYGGK/V6DtgoaUQIMGAlupgMTibM=;
 b=t0JcjHIaRICqs0i4NU+3jRZS9LGmffrczgWJJn70iTa/8VXJRmytX55gW0zL1Y5+ntnM
 1I5szL124E/wU9C36EP3GY415XZTC0xXlC160fm79YbETAUt9UrcQ+Vx9L6SANGWSxh4
 b/J6XrDeFpVinxeXF9YbkkJrattrkCLVMTe52EUhXy90SXZUKElUDhSYIxDlW08Yf1MA
 4g2YlFHDei5idgDEca3lgbA2D3270Ko2qm9YBbCDyJrym/WypfmL+x0c40J8MYL7D2f8
 11oyCvPqRhkHJxPpvtXpxT23BZP3ScZesfo2feHucAmNTmamqsPgP4LTsls073EIdctd qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbs12tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 15:15:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QFAuCw058070;
        Wed, 26 Aug 2020 15:13:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 333ru08n48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 15:13:04 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QFD23d006222;
        Wed, 26 Aug 2020 15:13:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 08:13:01 -0700
Date:   Wed, 26 Aug 2020 08:13:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <20200826151300.GM6096@magnolia>
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <20200825224144.GS12131@dread.disaster.area>
 <2210dced-9196-b42e-9205-4b9da3832553@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2210dced-9196-b42e-9205-4b9da3832553@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 09:32:13AM -0500, Eric Sandeen wrote:
> On 8/25/20 5:41 PM, Dave Chinner wrote:
> > On Tue, Aug 25, 2020 at 03:25:29PM -0500, Eric Sandeen wrote:
> >> The boundary test for the fixed-offset parts of xfs_attr_sf_entry
> >> in xfs_attr_shortform_verify is off by one.  endp is the address
> >> just past the end of the valid data; to check the last byte of
> >> a structure at offset of size "size" we must subtract one.
> >> (i.e. for an object at offset 10, size 4, last byte is 13 not 14).
> >>
> >> This can be shown by:
> >>
> >> # touch file
> >> # setfattr -n root.a file
> >>
> >> and subsequent verifications will fail when it's reread from disk.
> >>
> >> This only matters for a last attribute which has a single-byte name
> >> and no value, otherwise the combination of namelen & valuelen will
> >> push endp out and this test won't fail.
> >>
> >> Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> >> index 8623c815164a..a0cf22f0c904 100644
> >> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> >> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> >> @@ -1037,7 +1037,7 @@ xfs_attr_shortform_verify(
> >>  		 * Check the fixed-offset parts of the structure are
> >>  		 * within the data buffer.
> >>  		 */
> >> -		if (((char *)sfep + sizeof(*sfep)) >= endp)
> >> +		if (((char *)sfep + sizeof(*sfep)-1) >= endp)
> > 
> > whitespace? And a comment explaining the magic "- 1" would be nice.
> 
> I was following the whitespace example in the various similar macros
> i.e. XFS_ATTR_SF_ENTSIZE but if people want spaces that's fine by me.  :)
> 
> ditto for degree of commenting on magical -1's; on the one hand it's a
> common usage.  On the other hand, we often get it wrong so a comment
> probably would help.
> 
> > Did you audit the code for other occurrences of this same problem?

TBH I think this ought to be fixed by changing the declaration of
xfs_attr_sf_entry.nameval to "uint8_t nameval[]" and using more modern
fugly macros like struct_sizeof() to calculate the entry sizes without
us all having to remember to subtract one from the struct size.

> No.  I should do that, good point.  Now I do wonder if
> 
>                 /*
>                  * Check that the variable-length part of the structure is
>                  * within the data buffer.  The next entry starts after the
>                  * name component, so nextentry is an acceptable test.
>                  */
>                 next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
>                 if ((char *)next_sfep > endp)
>                         return __this_address;
> 
> should be >= but I'll have to unravel all the macros to see.  In that case
> though the missing "=" makes it too lenient not too strict, at least.

*endp points to the first byte after the end of the buffer, because it
is defined as (*sfp + size).  The end of the last *sfep in the sf attr
struct is supposed to coincide with the end of the buffer, so changing
this to >= is not correct.

--D

> In general though, auditing for proper "offset + length [-1] >[=] $THING"
> 
> where $THING may be last byte or one-past-last-byte is a few days of work, because
> we have no real consistency about how we do these things and it requires lots of
> code-reading to get all the context and knowledge of how we're counting.
> 
> Not really trying to make excuses but I did want to get the demonstrable
> flaw fixed fairly quickly.	
> 
> Thanks though, these are good points.
> 
> -Eric
> 
> > Cheers,
> > 
> > Dave.
> > 
