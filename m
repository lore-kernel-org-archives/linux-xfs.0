Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAD0C3F6B0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 16:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbiHEQgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Aug 2022 12:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238749AbiHEQfm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 12:35:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB7310F6;
        Fri,  5 Aug 2022 09:35:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275GYcbE015532;
        Fri, 5 Aug 2022 16:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9T8Jy/vR2vFtu/IT8XO3On3qxyi7z2RzzbtMhg/1wOE=;
 b=xmZzDBC/9FuVrWJLC84uzDDxy1t/fe8d14GRfK39LHBadKVy7EcHBXaJSnnk2K/9gFQ8
 Lf1IJq/w+pSoBv3PHPzk9qEjbZw+qbj5zOudGqRTOHpTAqQmcxM7fbZkpC+w508tJyxb
 jyCp3tgNLC1x1C0zsJ79tssbtIbzemapWaD7U1CmnITnMZ80YEvfuRdVtGOgzgaP83bD
 BQHD5FQONu690ulH69EaqPcn8tbEmoKEHn3fNvfgQnPC47G4ucYRcWBnL0j93jxmKaTh
 h8yx2L3EEZeCUb38PEhNGoM54V5bLeqXB5yZVQ+bqBqUuVLX4K6vIO66VVcGYNsUkSmw SQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue30b82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 16:35:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 275FKUI7010928;
        Fri, 5 Aug 2022 16:35:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu35ft1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 16:35:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haXP3wexGXZ0IDMdMu+L8RIKzIAIu8udwEvvehGEHTWtO5vVgyMsMZ6GNws6XxXwYfm6ny9V/stFIJLHZYbaF4paXnO1wRblKVJACakNwHFvlBOtaLnY0LdoUEqOzlthn3YkRiF53LLkEiBkyqdxmHRMBlMmnAU9kf9jrFa7Ter09qQABUNavjSlNt0tfSVfzZRXBYxpJA6fHEk6WS4349GxUWKGWtgNQbe+2KNfGV0v5oTgJqA5R09DhWu6Uxb3stJzjF7opszWme6+qN5Bp2GqzW10lpbnI/CootZFvlL9aKb8LlB123ca/o/XZB7oZ+fe3mCtTye4mjFx2tnocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9T8Jy/vR2vFtu/IT8XO3On3qxyi7z2RzzbtMhg/1wOE=;
 b=nNy1Az6JEUAijqvJmyfBdLdm8XXL9BI3ArdaKTs11c6F1lH5HNiBkyQoLeyJ/m/DFDSNNwXoF8nhA1ouxeH7/4BRubCq8jwTskHbGZHdRgqf6MG9wCsAK4EpBMSb6wJ5oAOJe7616PInkzQbexK/Rs9N2GQ2LsxjJEdXpjfNpWRnrgCv1d68LthHxmIh25dRQOCmeOdu0db68/lNtQ1Eomk3nBlq8yBEVJSepccSmre1JHRJuSi9IkIOGay4QimW+4sSEQor7JFpCrVHh6MA0+yJ47PmI0LwARUb/xAuyGGNlt4EA8yo13wMFnPuyOqh2WfAisPD1/eGcg0cuyQ8Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T8Jy/vR2vFtu/IT8XO3On3qxyi7z2RzzbtMhg/1wOE=;
 b=Wg/2pHfBNPyXtqrZDbXoRkMZUURxQk+r7ss8buCU5XpQPWEHMha1/2e27mpbFEd6jenuJhyXkPrmYVORAzJKo9W1vmnDoMF6H/K8PeW2DoY2b9xxJkMgH0J7DqlsQpteDj9KGiRhUK3Ab5tbirepMxF9vDJ+7vjT5/KcAN9vb/o=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BYAPR10MB2774.namprd10.prod.outlook.com (2603:10b6:a03:8b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 16:35:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b8df:5373:e1fe:3463]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b8df:5373:e1fe:3463%7]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 16:35:31 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] xfs/018: fix LARP testing for small block sizes
Thread-Topic: [PATCH v3 1/1] xfs/018: fix LARP testing for small block sizes
Thread-Index: AQHYqOlgt2hPe2JGu02J1h4nJMLMCw==
Date:   Fri, 5 Aug 2022 16:35:31 +0000
Message-ID: <0BF256D5-1CE1-4556-8966-E8D63301C2C1@oracle.com>
References: <20220805005552.34449-1-catherine.hoang@oracle.com>
 <Yuydc1fRmee0+a/b@magnolia>
In-Reply-To: <Yuydc1fRmee0+a/b@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1c735ea-0ccf-4ead-67b7-08da7700834f
x-ms-traffictypediagnostic: BYAPR10MB2774:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YIArTFJdGet+vzLzPnOhP0js00DhqestOiY7n2BMl5T5mDqrc6kqkERtAfy0lebO7nv67k+5RsvnOufYOd7H9JlP25M5xbCEFM+ouikAxRAtk+tZ/PqG9J6JbBWJCRx9eMbPsOqUMdMriSE9zMJn/g+LIQgA7VBGN4y7AYzdGqwpCI69Ymqtljin0vERG1GYU6PfLqx4Xahq0AQ5MXoyetW9HQ5fqU4gRjhjidKMk+iJXmzWyr+wst4NyD7juipzMufDnzk8OzMM7/7f7m6KJlw1/mjRQyNuIerwO5qBEH14dCR0932wmdym9b/1xFYj53ARg61Hfu5oqftU/bPC2WoeYb48HyRKSA1ycl/pQfJXSy6QvEtNk7ObTjTVfJq+UaFA1ULQiWauYoffeWA0WVVYU9fHhiEJkqygSHsgxhG2dxC+8d0i+2NSTaAyXOCFeYbgw/hCQhZvMg1iZIj+4D6M5Td5t8dDta+c75uR59lCma4UE/TqTDGrh62EBj5PecvwSrCeODTrJmpe223by58ecyWtbvsVX4e+gcvLjXq1phDw/2ePqqptrhpOlOsi7gU/wWw8kQrXY5unjNJRK/+faqjZDo/wkpz0JOUa0I149kS1+2e92Kz+dDJ3AeRPGuhfYN3uaHb9QHBMFMu5adhTznrp256afEe9nhtuqlU/nKLuX9E+aqXKy2OwLDne75w76HWSdczEgdSIDnRB4MLNqexubnbC3BLqe+3JfX+wweZ2snV7f5Bsh5HkJUtda/1mp/l5rgabFhR7HauokWJJa3QfHKKZ/F+2lGO5Tsu8zbQ/hj8K/89gybDs+0hcmceg5QdwjMqGYtPDb+gn9VNI45Pcph3anlHv5t/gnuo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(136003)(376002)(346002)(64756008)(478600001)(41300700001)(86362001)(6506007)(53546011)(5660300002)(66476007)(2906002)(33656002)(30864003)(44832011)(6486002)(71200400001)(4326008)(83380400001)(2616005)(26005)(6512007)(186003)(38070700005)(8936002)(122000001)(38100700002)(76116006)(36756003)(54906003)(91956017)(6916009)(66946007)(66446008)(66556008)(8676002)(316002)(45980500001)(357404004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/QmUXBUUs200lX6PTm6x+nM384YyeRmrzxiZ0X3OxxKgaODxgQ2jJPWlUtxN?=
 =?us-ascii?Q?mhNavQgVzp41eF1vmOgSwlvTcbPLgE6rpu3gDmeKp4Fb9YVVAmS3M+Jgvp7i?=
 =?us-ascii?Q?IJ3vZBzfrkDSzzSbKAlUbEqc1kxM6f6tHi6aIGYMzewf1CuO4H0A++Ii3X+A?=
 =?us-ascii?Q?//dMJa05yM65Tdx6LrhnBxIe/pmtFtJLEmo+kpJUDHQvcARaq3A/loBuoLO4?=
 =?us-ascii?Q?B6zYXGQFz/NC+DzBd+CKlN7HOYMd33fxqMV2WMbqJsxyWOfbFzB2v1A0Sy49?=
 =?us-ascii?Q?vg4V2M3vMrKElGxRIO5TkmwmtYbUnafD7zbFt90Has0aCtMJhHASBcwh5Umd?=
 =?us-ascii?Q?De5iBHTV0cMjtpPcqy2MbC/sLt6f7hmzfxC3dQ1ixgt6mD7t+YMZ2B5FoGWU?=
 =?us-ascii?Q?bb0RIG7gokGVbytyVSJ/pvj9g98JNwbY17gQ5pjn6E/XWly6s0Ke7wjaJP/R?=
 =?us-ascii?Q?/nt9TWEuvl2wpicLMyo+fBGWF73CNcPBHCjHAls0HEjgj79VmG271hnEQzPw?=
 =?us-ascii?Q?PkxVuzphgwhdmL7acnDIndcKGTHxMf/G/zJDL5tTn++C/pIUkWRAHAyyufvb?=
 =?us-ascii?Q?MvYN3HpOZfLV5cDnJBqpoIc6bwUXa7EMslzwI1Lxm53XHf2fU6udu6GTSyQE?=
 =?us-ascii?Q?eVVGhVKPchx4uNIWhe4/aAqG7MwUtEn1FGhBoANRK/2frizeZOnbIEyoapbv?=
 =?us-ascii?Q?lIc4JY7Xlzl9zfhRseWj1ocO3tk4wt1pECric20Cd+gaFxX7zP9d3cj1PSNd?=
 =?us-ascii?Q?ZLUOyJocAu/QCcqz7q/iGyBKb6HxV7oXr1vTmiwmngB571XDfyoenxflAvlS?=
 =?us-ascii?Q?BeC7gZzzJ+ycnus29Qg8KOMz+ZSc5UIKg/8oS39CzvT7k1R2rGaT40GWop1Z?=
 =?us-ascii?Q?pgpwQ8Mw9gQJDdL5dD4k/n2ZmszzUZweCINaGnF0kjdHtT3HpUD+Gs/AlZw5?=
 =?us-ascii?Q?fDTOzyEr3ad2wJYgP8DmgWJASXX/3OgCzCMI6HJZLuysqHLCd91TfJGjhWXY?=
 =?us-ascii?Q?fFEeYE7CYw2djK3TO5CBomR3B+oe6bKa7UHIcWJj2SUoKty3TqvOf9GTBCAv?=
 =?us-ascii?Q?yEVAVq2MGxu/eCCkZRqWlLaWq2BzT2M/t/7Bfi3udLxXyhoz0ulorLgoK9eV?=
 =?us-ascii?Q?cKqzICyKSfNwhIKskGbcduKhTVpz7GQMxdFH0b9H0c2SOcik5U1vGmgFHiZ7?=
 =?us-ascii?Q?2Qcb/cXAoif6mHpnwndlCA/eRj8QuG2ZCfCYXZpaapfOlIH5An/JN/sn8mwL?=
 =?us-ascii?Q?DJfeXuuT5BhYENvxhSjyWmjqnXsMiD5uQJEj1xZL/KSBnfR9wWRjPiNMu2HM?=
 =?us-ascii?Q?ZxNKpKdyXZ1wylLQWgQVaag9ug4DJnTFN5imL8/qkT99+OV5blFlk9nuOrVU?=
 =?us-ascii?Q?P0xJPfBh0k61g9b4uBB52TennbCgiQv2iMg/72/DrE9iYzqfcb0szJZntDWV?=
 =?us-ascii?Q?bkKiEOGz0HKP07ybkal5i9DxaHf6JNzsNjRV8Q8HnZtK+++4isQbfiBoBrdh?=
 =?us-ascii?Q?HbT0BfpL1Ey5yhuekXM8BkJhOjmfXhQXnQSjOEYmbG6IYCC2/WrPIx+dilZk?=
 =?us-ascii?Q?Hwm26GiFwNbkKXSFpIPyUHgDxgMGGTZLoROxKDyIhBl3G/QQ8e4Lk/HH1SRA?=
 =?us-ascii?Q?Kw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A44305DC8B3C84192DFAAD76A2BBC48@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c735ea-0ccf-4ead-67b7-08da7700834f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 16:35:31.2602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dul9r2RFee3m48H1anS1XEK82RBH3ptH25HvcYhO96MxRJVZxzJTI0ARNtlyTPg3MZDqus9x+YZaoXGSe+jxQz2y3DHlPdsFQkJjUjjXFE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_09,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050079
X-Proofpoint-ORIG-GUID: izitkSiCf3cF68S-CHefxhfznNN-vPyu
X-Proofpoint-GUID: izitkSiCf3cF68S-CHefxhfznNN-vPyu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Aug 4, 2022, at 9:32 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Thu, Aug 04, 2022 at 05:55:52PM -0700, Catherine Hoang wrote:
>> From: "Darrick J. Wong" <djwong@kernel.org>
>>=20
>> Fix this test to work properly when the filesystem block size is less
>> than 4k.  Tripping the error injection points on shape changes in the
>> xattr structure must be done dynamically.
>>=20
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>=20
> Hmm, this patch got its start with things that I wrote...
>=20
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>> tests/xfs/018     | 15 ++++++++++-----
>> tests/xfs/018.out | 43 ++-----------------------------------------
>> 2 files changed, 12 insertions(+), 46 deletions(-)
>>=20
>> diff --git a/tests/xfs/018 b/tests/xfs/018
>> index 041a3b24..1b45edf4 100755
>> --- a/tests/xfs/018
>> +++ b/tests/xfs/018
>> @@ -47,7 +47,8 @@ test_attr_replay()
>> 	touch $testfile
>>=20
>> 	# Verify attr recovery
>> -	$ATTR_PROG -l $testfile | _filter_scratch
>> +	$ATTR_PROG -l $testfile >> $seqres.full
>> +	echo "Checking contents of $attr_name" >> $seqres.full
>> 	echo -n "$attr_name: "
>> 	$ATTR_PROG -q -g $attr_name $testfile 2> /dev/null | md5sum;
>>=20
>> @@ -98,6 +99,10 @@ attr64k=3D"$attr32k$attr32k"
>> echo "*** mkfs"
>> _scratch_mkfs >/dev/null
>>=20
>> +blk_sz=3D$(_scratch_xfs_get_sb_field blocksize)
>> +err_inj_attr_sz=3D$(( blk_sz / 3 - 50 ))
>> +err_inj_attr_val=3D$(printf "A%.0s" $(seq $err_inj_attr_sz))
>=20
> ...though I think this particular strategy (using attr values that are
> ~1/3 the block size) is novel.  I wonder if this deserves a comment on
> the calculation, though?
>=20
> I think the idea here is that we want to build up exactly one attr leaf
> block by setting user.attr_name[1-3]; and then the fourth one is
> guaranteed to cause a split in the fileoff 0 leaf block, which is enough
> to trip both the da_leaf_split and attr_leaf_to_node injectors?
>=20
> The reason why we have the same userspace code but two different trip
> points is that we're trying to test recovery from two different points
> in the xattr state machine, right?  So the test code looks identical,
> but we're testing two separate things, right?

The two injection points are used to test recovery at two different states,
and they can both be tripped by the addition of the fourth attribute (which
doesn't fit in the leaf block). So yes to all three questions. Thanks for
reviewing!
>=20
> Assuming that all three answers are yes, then I'm satisfied by this new
> approach that is much simpler than the one I came up with:
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>=20
> --D
>=20
>=20
>> +
>> echo "*** mount FS"
>> _scratch_mount
>>=20
>> @@ -140,12 +145,12 @@ test_attr_replay extent_file1 "attr_name2" $attr1k=
 "s" "larp"
>> test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
>>=20
>> # extent, inject error on split
>> -create_test_file extent_file2 3 $attr1k
>> -test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
>> +create_test_file extent_file2 3 $err_inj_attr_val
>> +test_attr_replay extent_file2 "attr_name4" $attr256 "s" "da_leaf_split"
>>=20
>> # extent, inject error on fork transition
>> -create_test_file extent_file3 3 $attr1k
>> -test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_no=
de"
>> +create_test_file extent_file3 3 $err_inj_attr_val
>> +test_attr_replay extent_file3 "attr_name4" $attr256 "s" "attr_leaf_to_n=
ode"
>>=20
>> # extent, remote
>> create_test_file extent_file4 1 $attr1k
>> diff --git a/tests/xfs/018.out b/tests/xfs/018.out
>> index 022b0ca3..415ecd7a 100644
>> --- a/tests/xfs/018.out
>> +++ b/tests/xfs/018.out
>> @@ -4,7 +4,6 @@ QA output created by 018
>> attr_set: Input/output error
>> Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
>> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output erro=
r
>> -Attribute "attr_name" has a 65 byte value for SCRATCH_MNT/testdir/empty=
_file1
>> attr_name: cfbe2a33be4601d2b655d099a18378fc  -
>>=20
>> attr_remove: Input/output error
>> @@ -15,7 +14,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>> attr_set: Input/output error
>> Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
>> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output erro=
r
>> -Attribute "attr_name" has a 1025 byte value for SCRATCH_MNT/testdir/emp=
ty_file2
>> attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
>>=20
>> attr_remove: Input/output error
>> @@ -26,7 +24,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>> attr_set: Input/output error
>> Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
>> touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output erro=
r
>> -Attribute "attr_name" has a 65536 byte value for SCRATCH_MNT/testdir/em=
pty_file3
>> attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>>=20
>> attr_remove: Input/output error
>> @@ -37,132 +34,96 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
>> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output err=
or
>> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inli=
ne_file1
>> -Attribute "attr_name2" has a 65 byte value for SCRATCH_MNT/testdir/inli=
ne_file1
>> attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
>>=20
>> attr_remove: Input/output error
>> Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
>> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output err=
or
>> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inli=
ne_file1
>> attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
>> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output err=
or
>> -Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/in=
line_file2
>> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inli=
ne_file2
>> attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>>=20
>> attr_remove: Input/output error
>> Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
>> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output err=
or
>> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inli=
ne_file2
>> attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
>> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output err=
or
>> -Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/i=
nline_file3
>> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inli=
ne_file3
>> attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>>=20
>> attr_remove: Input/output error
>> Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
>> touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output err=
or
>> -Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inli=
ne_file3
>> attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
>> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output err=
or
>> -Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/ex=
tent_file1
>> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file1
>> attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>>=20
>> attr_remove: Input/output error
>> Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
>> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output err=
or
>> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file1
>> attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
>> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output err=
or
>> -Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/ex=
tent_file2
>> -Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file2
>> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file2
>> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file2
>> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
>> +attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
>> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output err=
or
>> -Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/ex=
tent_file3
>> -Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file3
>> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file3
>> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file3
>> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
>> +attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
>> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output err=
or
>> -Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/e=
xtent_file4
>> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file4
>> attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>>=20
>> attr_remove: Input/output error
>> Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
>> touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output err=
or
>> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/ex=
tent_file4
>> attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
>> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output err=
or
>> -Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/re=
mote_file1
>> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/r=
emote_file1
>> attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>>=20
>> attr_remove: Input/output error
>> Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
>> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output err=
or
>> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/r=
emote_file1
>> attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
>> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output err=
or
>> -Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/r=
emote_file2
>> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/r=
emote_file2
>> attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>>=20
>> attr_remove: Input/output error
>> Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
>> touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output err=
or
>> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/r=
emote_file2
>> attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
>> touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
>> -Attribute "attr_name1" has a 64 byte value for SCRATCH_MNT/testdir/sf_f=
ile
>> -Attribute "attr_name2" has a 17 byte value for SCRATCH_MNT/testdir/sf_f=
ile
>> attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
>> touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
>> -Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/lea=
f_file
>> -Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/le=
af_file
>> -Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/le=
af_file
>> attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>>=20
>> attr_set: Input/output error
>> Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
>> touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
>> -Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/nod=
e_file
>> -Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/n=
ode_file
>> attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>>=20
>> *** done
>> --=20
>> 2.34.1
>>=20

