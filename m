Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE89C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 22:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiGGW6S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGGW6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 18:58:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B5D61D60;
        Thu,  7 Jul 2022 15:58:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCQM0003643;
        Thu, 7 Jul 2022 22:58:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vHb+Wiqq907ji1MmaS68c6YE+2BIbqZDmsfRkVLebiI=;
 b=X9h6uOS9XwZeVi3kI6p7BKOQaiIxuhZkoPj/Np1xxLOObCgpGVCaAxmGKsE5b/4guuT1
 28egKSKWVAIKSOcdQ7TpKRTEwWmDZWDdOQykLEVJrkDUfoSjXAxiEt0nY97qP78sA7Hn
 j/HIBCz/A8SYCsOON7x4CPG65IGaDhhAgDOSKxDQ0cRrkFkmv8YWPsOZG4l9uXVoEZLK
 zUvEAJmEl7hbKZI0T2mXsad66Rjbehxo4zZ/9dRjsuWhmgKEvxEcsGhAOtVO13ggW+9X
 f2efZVUmRlloe3ZPo0AmolE/2gWTM7XLbbe1rqh63EmN/BMtDAee5+h3lK37Vhy7gpcm Tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyea4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 22:58:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267Mjg8n020914;
        Thu, 7 Jul 2022 22:58:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud680b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 22:58:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUjXip68c2TCJh0WQSkMsZL7gc5QgxrQXoQbaRTXN9XljxpAw1/A+YIG76ZOnLH6l9rm5/6BGSAAfRdUYqqf5C88PbyCs8FvioUe/kiXv4N4NiCyL1IwNJz9HSofiiWt30jrWn5F2eRO/cUqwPPWZdJ7b+O3YSAZFuynETFtgM/IxFgf3Z2fXz0rXNAJz5dtPOUi2GwmEiSYk5Uz8RJxA0Ns7OhqtzM5nNWBYQlrTOUdW96ZYFicZPmI+W4FIuVPZY15rRWrML7X6/te3x2mhz6cT0TJyzZJhhTJyrWqsatS4D4vcgVxhpiwY+siPfM5LkEXH508Bg1iYwd/QT/eJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHb+Wiqq907ji1MmaS68c6YE+2BIbqZDmsfRkVLebiI=;
 b=fR++Js2p3+jGh2wyV+KzDF1CC7GWBwr/hqqOXNC7iid3lOWk23yWLJ3p0G5pRz4RzmH5D+e4xdfFAUsgumjdO2En711VtvkYk1XYPf4D0XwFrQoT4/YRrc0amk/xrGWsTv8KUyuFfovxEo6msQXPhuVyQWH7armluY34XfL4Bc3HFm3wK/d196Nevfkg/WV64DF+kos4/mrQtUveA6U+zHVFZjqRlD76lSZ2tVptOCpKHWp+N+ELGDjcSOHd3kcg/oXYjtm+l9tY7QuhRgxCkDONDWsqsYihfxvrTkWjfM2MIAyQqrMh86swzsBPLBE7jFQmBvHiyj3zs6pGBvo5qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHb+Wiqq907ji1MmaS68c6YE+2BIbqZDmsfRkVLebiI=;
 b=btkLGyxuTheFk6ynOjvSAaGiTD0Ab9QrlwOUrxk87o5mIcR4okfG/wD5gJh7U1YKLbtAnsb6muUIfbvg7FvLiV32z6KFzOztNluuo/3E3YSs/OJOjE5/Zv3aD/AuFpBQYzfW92BEXmIY3mrH/jrZDVONdWh3gyaYXCWKJC9XdM8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MWHPR10MB1455.namprd10.prod.outlook.com (2603:10b6:300:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 22:58:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5417.019; Thu, 7 Jul 2022
 22:58:01 +0000
Message-ID: <6d94b670ebca8271017b1c002e9d177da8d25eeb.camel@oracle.com>
Subject: Re: [PATCH 2/3] xfs/018: fix LARP testing for small block sizes
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me,
        Catherine Hoang <catherine.hoang@oracle.com>
Date:   Thu, 07 Jul 2022 15:57:59 -0700
In-Reply-To: <YsdZv6AF7tyalkZz@magnolia>
References: <165705852280.2820493.17559217951744359102.stgit@magnolia>
         <165705853409.2820493.9590517059305128125.stgit@magnolia>
         <YscglleRpAIkrHiA@magnolia>
         <89d1e21b688d880b200f9dd32891023b55726735.camel@oracle.com>
         <YsdZv6AF7tyalkZz@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af3388c9-ec43-4adc-dfca-08da606c2448
X-MS-TrafficTypeDiagnostic: MWHPR10MB1455:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVk4SzdsFuiUBFnOShwAfiktoMLLfKOc07TWGDPNal8GFx6dZTRlUBOWA793vLyrynW7HBf3tciTL2EKQP6cJmjXGH4kVvU+uXbQvuQJ5DLvXcbVBw9Ugqd1YlnGo3TKU1DVI9dMjWqwAdf8kJZvY1C3edSp1WKynow+YYE1w+6mv5USh2zI8THJpurG+H7+PoL5cBUb/Wchs2EorGaXgZB8yqzyIZzLTD0h1MztDpoGbAzZFQFdFZ0bgi8G60PNNQx5aBdJvN7SSBUXHLalH2XjOTRdZ0Mc5EFVY50mkyPCk4SpCa4IPrWlHpFVOjiyD3cjh+2Vm5wntTEODxRpjIJAvR8soCwyopvJ1yyspUk6XbHrBbDd8vayUan930aY7CeUSbROfLM2RF0/eve2Qsd72B0RighuGbpEd3RbDBQQIWyQ0QsTvEYt5k5Eh2iaWAvSfyCh3w4JNcvaiYjBlG70nRezauarXJySRXrcEi3xX9vZ3guAz0E9UaHxSVU3sf2kD3/18aK74TFE08lBgL97oXhY1nOvVHg2ab7nv8Lt5JOjaNgcqHgG3mx3CxIo9XfMJvfV+9N/GsazZ1sl/h8fzRdd1wF8uFkqIcRqg6H5VphV0HFozTU/SaktNCGYSMDIftJiDCMMO4hUAkbUj/m8e7OXpv9ebnH2YnM+3NK6416Gd8B6CntETSWHAMRMJxwHrlg4MCjPscxFPXdf3YfdldOe223mhH7FxdWlz+BoGgR4sRfHk9/CPVBCPQwVsi75uLdMMTTpk8NfmlJKjdHhAI5u5ic4/Q0GJYjWzrRkBTDQDewZwp8+BPIOlO1LG0V6YGIfnWBcseEhjBYRFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(39860400002)(396003)(376002)(2906002)(41300700001)(38350700002)(6486002)(478600001)(38100700002)(86362001)(66946007)(66476007)(83380400001)(2616005)(107886003)(4326008)(6506007)(8676002)(66556008)(26005)(52116002)(8936002)(6916009)(6512007)(36756003)(316002)(5660300002)(186003)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emRDNWEvbldPMnlaeEx3amRZUG50YlJHL3ZYMEhBUG1JNHFSVFQ5ZEU2V0ZC?=
 =?utf-8?B?WHlaRENEMDM5MVJIcnRLd0ZWcm1TaFdzRjFWQjdxT2wyQjdBNGhjVTZJSDM3?=
 =?utf-8?B?SzlENEQyZUw1NFdWMHQwY0NjSlppU1k1Mi9zSTl4SkE3LzRma1F1S2JFekpm?=
 =?utf-8?B?WTZSRCt1c0ZzbWpYZ3c5ZjI2NGEwUXh0dFNwbVAvRFFobDh6TzZDRkJMakxK?=
 =?utf-8?B?OXpydCtUVnFQUUt4YUVkbEtJcmhiV2ZRODlUSFNBYlJYczVEYkhVOVQ3MnNN?=
 =?utf-8?B?dnAxeUpidkduaU0ySEZaN0hQWGVOLzNONEFZUEl0MHV6c3lCeVY2TGVXTnBh?=
 =?utf-8?B?S3I3Zm53NXhoaFpvT1Qwb1l5NlIwclBnSCtvYkxhUVdMelJaV0I4MzFqczVJ?=
 =?utf-8?B?Q0Mvb1BqUzVEVm1xYXRlclN1bm9KZjBwUUF3cGlVT1MrMFNHNHNPN3BNWGxt?=
 =?utf-8?B?cFh0ekJOVDYzTWhHMUg5bVhYa2xmQnJ4N3ZhelE4ejd4dnYzQWNROUwxUGZw?=
 =?utf-8?B?V2NjeGthVlBNbXZ2eTl0c2F1dEVxb0J5WVhJVGNZL2lmUEFyYTkwTHZ4MDJG?=
 =?utf-8?B?QXJieVA1eklQWWdBMmdOQWpFYlBnTnp5UENlRndxcmdJYTFxZExPTDU5NWk1?=
 =?utf-8?B?STc1Sy8wMVJ0R0R3QUtoZmhtZUtXWHJTK0VqMjJjZ0lNOE5tb0cyZHdKVFo1?=
 =?utf-8?B?N0JxZWJrUXNadmRYbzZ1cEhiSmFXNjFNSExYNDNqbDRyc0NHZzVIYm1jU0kr?=
 =?utf-8?B?cUF1eVBpNlZic1JyL2VyZnF6L0MxRzMzV3Y2RURROUdzZ0JGL1ZINUtFcVRI?=
 =?utf-8?B?T1BPbDk2dmQ2YkRnc1ZYNUJEV05ON2pWSVBGcGdWQTcrWXovWFBYNXZFcDM5?=
 =?utf-8?B?YXFVZm5mR01SVE5ZUUEreWVieGpQYkMvRTZqdjJyYVJNSHV0SkorZ1lhaldF?=
 =?utf-8?B?cWszUERvM2o1aEpCSHBpTFYyS0NROHVQZE10SkdWbjZnZEd6VCtOckJsNEpS?=
 =?utf-8?B?SXQ1bFJqTzRVOHh0THc1dVZsdmNQM1dPYnVCYXo4a3lTVnZPM0RWWUNiMUQ1?=
 =?utf-8?B?YlhtSXRUZEpLWldIcUlOdDR3MURucjYrQVZYSTlibkJ2ZythTzVxb0E2eGRZ?=
 =?utf-8?B?aDh3VUZSUEhrRVFSWE5lclkzUW9lR1Bzd0ZURmQrK0oyRkNJcVZaZWxMUlY3?=
 =?utf-8?B?U0tDdEtOY3VZTDYyU2p0dkltZzMzK21OR0NyMzFPZEZQaVYvdmNUUkxZelRq?=
 =?utf-8?B?TXBhWGJDUXU5MitCajBHcGhlOWp6ZXl4VEhHMTcwZG04TzZ4Z2xNZWFTaFky?=
 =?utf-8?B?M01IaEdLa1dLdEJMZEU4aW9tN1VaRnBKSzdSRXJGdFRXRkE0bURBOGdIUzhN?=
 =?utf-8?B?RDVOUTVtd3RYMkFUMGhVcHBSV21sWGd5c1VqRTBVSUxHYkZkZURjTmtTZDBy?=
 =?utf-8?B?dXcyUE16WEFxWnJUeDh0cjNDVndvN0VyelpwKzVtanpqU2Q2REFqOWRyVWxQ?=
 =?utf-8?B?UmtZY291WXVVajA3V1E3UVlTZU5CVnNTcWtCeGhhV2xvNmo2ekVOSzJpaWVI?=
 =?utf-8?B?cVBOcjFVb0pUWjhtKytvMTMxekd1V3hZNlBrYmZJMi9hSEYvUER5Qkt2bi9U?=
 =?utf-8?B?MGRNdTFUaWxnK2M2ZDAzTnVWRko1a1JWV0lEdVpnemZYNjNZbFJqSjBSek5Z?=
 =?utf-8?B?NXdZdXVyYll3TWpzRk5RZExwM3p4QktPSUNLTjVMYW5VNVo4SHNSdjVhR1B6?=
 =?utf-8?B?aE1vOHpIWGN5M3NVL054Q2V3M0R2QUZ0bUhNdUhEVXJGQ3NHWk1CanJEMlZS?=
 =?utf-8?B?SXFoMTdoNzVUU0p1OTdGV0VhWFlqSnBHWGV0cituK3BPbUpXZFRuZTZKYzM0?=
 =?utf-8?B?emw3Z0ppL1grblF0REpOOGE5WGE5Yy96eDArSGFmYTNHUlF1bGtTSVdlbmE2?=
 =?utf-8?B?LzBRN012a2srOHB5TVNEQ0FJYjgrdGw2c1d2NmczaCsybGJydk5RKythelZX?=
 =?utf-8?B?eEswOXViUE9BeFhLMk1hU3RDQkc3MDI3Ym5ONnBGeEhIamxqSEM0RjhwMk1u?=
 =?utf-8?B?TXN5ZTFiTmJZeGlpOE9EVkJSekJ0NDJtb3dVOTNIZi8yMjhqTDRJY1BrV0NX?=
 =?utf-8?B?QVVTaGxBMmw2ZzcyblB2TmNHMnViYm8yQ3RBNVBuOWdqWldwV2lPaE5nMm14?=
 =?utf-8?B?OVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3388c9-ec43-4adc-dfca-08da606c2448
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 22:58:01.0802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZH1Fb/NCXJFOCacnaByhUptatBDqWCNIVVKFCdVNtSFdQf6quoapf0AWAfFvWulqDBsFTwSOWaEHL6fSfhQqEKSf75JZx1sa/JBWClhXrqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1455
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070089
X-Proofpoint-GUID: PkjyVbLX6ZNvIcAUbjRITkgxa6U5LB3S
X-Proofpoint-ORIG-GUID: PkjyVbLX6ZNvIcAUbjRITkgxa6U5LB3S
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-07-07 at 15:10 -0700, Darrick J. Wong wrote:
> On Thu, Jul 07, 2022 at 02:55:07PM -0700, Alli wrote:
> > On Thu, 2022-07-07 at 11:06 -0700, Darrick J. Wong wrote:
> > > I guess I should've cc'd Allison and Catherine on this one.
> > > 
> > > Could either of you review these test changes, please?
> > > 
> > > --D
> > > 
> > > On Tue, Jul 05, 2022 at 03:02:14PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Fix this test to work properly when the filesystem block size
> > > > is
> > > > less
> > > > than 4k.  Tripping the error injection points on shape changes
> > > > in
> > > > the
> > > > xattr structure must be done dynamically.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/018     |   52
> > > > +++++++++++++++++++++++++++++++++++++++++++++++-----
> > > >  tests/xfs/018.out |   16 ++++------------
> > > >  2 files changed, 51 insertions(+), 17 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/018 b/tests/xfs/018
> > > > index 041a3b24..14a6f716 100755
> > > > --- a/tests/xfs/018
> > > > +++ b/tests/xfs/018
> > > > @@ -54,6 +54,45 @@ test_attr_replay()
> > > >  	echo ""
> > > >  }
> > > >  
> > > > +test_attr_replay_loop()
> > > > +{
> > > > +	testfile=$testdir/$1
> > > > +	attr_name=$2
> > > > +	attr_value=$3
> > > > +	flag=$4
> > > > +	error_tag=$5
> > > > +
> > > > +	# Inject error
> > > > +	_scratch_inject_error $error_tag
> > > > +
> > > > +	# Set attribute; hopefully 1000 of them is enough to
> > > > cause
> > > > whatever
> > > > +	# attr structure shape change that the caller wants to
> > > > test.
> > > > +	for ((i = 0; i < 1024; i++)); do
> > > > +		echo "$attr_value" | \
> > > > +			${ATTR_PROG} -$flag "$attr_name$i"
> > > > $testfile >
> > > > $tmp.out 2> $tmp.err
> > > > +		cat $tmp.out $tmp.err >> $seqres.full
> > > > +		cat $tmp.err | _filter_scratch | sed -e
> > > > 's/attr_name[0-
> > > > 9]*/attr_nameXXXX/g'
> > > > +		touch $testfile &>/dev/null || break
> > > > +	done
> > > > +
> > > > +	# FS should be shut down, touch will fail
> > > > +	touch $testfile 2>&1 | _filter_scratch
> > > > +
> > > > +	# Remount to replay log
> > > > +	_scratch_remount_dump_log >> $seqres.full
> > > > +
> > > > +	# FS should be online, touch should succeed
> > > > +	touch $testfile
> > > > +
> > > > +	# Verify attr recovery
> > > > +	$ATTR_PROG -l $testfile >> $seqres.full
> > > > +	echo "Checking contents of $attr_name$i" >>
> > > > $seqres.full
> > > > +	echo -n "${attr_name}XXXX: "
> > > > +	$ATTR_PROG -q -g $attr_name$i $testfile 2> /dev/null |
> > > > md5sum;
> > > > +
> > > > +	echo ""
> > > > +}
> > > > +
> > 
> > Ok, I think I see what you are trying to do, but I think we can do
> > it
> > with less duplicated code and looping functions.  What about
> > something
> > like this:
> > 
> > diff --git a/tests/xfs/018 b/tests/xfs/018
> > index 041a3b24..dc1324b1 100755
> > --- a/tests/xfs/018
> > +++ b/tests/xfs/018
> > @@ -95,6 +95,9 @@ attr16k="$attr8k$attr8k"
> >  attr32k="$attr16k$attr16k"
> >  attr64k="$attr32k$attr32k"
> >  
> > +blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> > +multiplier=$(( $blk_sz / 256 ))
> 
> The scratch fs hasn't been formatted yet, but if you use
> _get_block_size
> after it's mounted, then, yes, I'm with you so far.
> 
> > +
> >  echo "*** mkfs"
> >  _scratch_mkfs >/dev/null
> >  
> > @@ -140,7 +143,7 @@ test_attr_replay extent_file1 "attr_name2"
> > $attr1k
> > "s" "larp"
> >  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
> >  
> >  # extent, inject error on split
> > -create_test_file extent_file2 3 $attr1k
> > +create_test_file extent_file2 $(( $multiplier - 1 )) $attr256
> 
> Hm.  The calculations seem slightly off here -- name is ~8 bytes
> long,
> the value is 256 bytes, which means there's at least 264 bytes per
> attr.
> I guess you do only create multiplier-1 attrs, though, so that
> probably
> works for all the blocksizes I can think of...
> 
> >  test_attr_replay extent_file2 "attr_name4" $attr1k "s"
> > "da_leaf_split"
> 
> If we keep the 1k attr value here, do we still trip the leaf split
> even
> if that 1k value ends up in a remote block?
I think so.  If I'm following the code correctly, it moves through the
states in order.  As long as we run across the node state in the state
machine, da_leaf_split should trip.

> 
> >  # extent, inject error on fork transition
> > 
> > 
> > 
> > Same idea right?  We bring the attr fork right up and to the edge
> > of
> > the block boundary and then pop it?  And then of course we apply
> > the
> > same pattern to the rest of the tests.  I think that sort of reads
> > cleaner too.
> 
> Right, I think that would work in principle.  Does the same sort of
> fix
> apply to the "extent, inject error on fork transition" case too?
> 
I think it should.  These two tests have the same set up really, the
only difference is where the error tag is set.  So as long as the next
attr is enough to catapult us through node, we should hit that state in
the state machine.

Allison

> --D
> 
> > Allison
> > 
> > > >  create_test_file()
> > > >  {
> > > >  	filename=$testdir/$1
> > > > @@ -88,6 +127,7 @@ echo 1 > /sys/fs/xfs/debug/larp
> > > >  attr16="0123456789ABCDEF"
> > > >  attr64="$attr16$attr16$attr16$attr16"
> > > >  attr256="$attr64$attr64$attr64$attr64"
> > > > +attr512="$attr256$attr256"
> > > >  attr1k="$attr256$attr256$attr256$attr256"
> > > >  attr4k="$attr1k$attr1k$attr1k$attr1k"
> > > >  attr8k="$attr4k$attr4k"
> > > > @@ -140,12 +180,14 @@ test_attr_replay extent_file1
> > > > "attr_name2"
> > > > $attr1k "s" "larp"
> > > >  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
> > > >  
> > > >  # extent, inject error on split
> > > > -create_test_file extent_file2 3 $attr1k
> > > > -test_attr_replay extent_file2 "attr_name4" $attr1k "s"
> > > > "da_leaf_split"
> > > > +create_test_file extent_file2 0 $attr1k
> > > > +test_attr_replay_loop extent_file2 "attr_name" $attr1k "s"
> > > > "da_leaf_split"
> > > >  
> > > > -# extent, inject error on fork transition
> > > > -create_test_file extent_file3 3 $attr1k
> > > > -test_attr_replay extent_file3 "attr_name4" $attr1k "s"
> > > > "attr_leaf_to_node"
> > > > +# extent, inject error on fork transition.  The attr value
> > > > must be
> > > > less than
> > > > +# a full filesystem block so that the attrs don't use remote
> > > > xattr
> > > > values,
> > > > +# which means we miss the leaf to node transition.
> > > > +create_test_file extent_file3 0 $attr1k
> > > > +test_attr_replay_loop extent_file3 "attr_name" $attr512 "s"
> > > > "attr_leaf_to_node"
> > > >  
> > > >  # extent, remote
> > > >  create_test_file extent_file4 1 $attr1k
> > > > diff --git a/tests/xfs/018.out b/tests/xfs/018.out
> > > > index 022b0ca3..c3021ee3 100644
> > > > --- a/tests/xfs/018.out
> > > > +++ b/tests/xfs/018.out
> > > > @@ -87,22 +87,14 @@ Attribute "attr_name1" has a 1024 byte
> > > > value
> > > > for SCRATCH_MNT/testdir/extent_file
> > > >  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
> > > >  
> > > >  attr_set: Input/output error
> > > > -Could not set "attr_name4" for
> > > > SCRATCH_MNT/testdir/extent_file2
> > > > +Could not set "attr_nameXXXX" for
> > > > SCRATCH_MNT/testdir/extent_file2
> > > >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2':
> > > > Input/output error
> > > > -Attribute "attr_name4" has a 1025 byte value for
> > > > SCRATCH_MNT/testdir/extent_file2
> > > > -Attribute "attr_name2" has a 1024 byte value for
> > > > SCRATCH_MNT/testdir/extent_file2
> > > > -Attribute "attr_name3" has a 1024 byte value for
> > > > SCRATCH_MNT/testdir/extent_file2
> > > > -Attribute "attr_name1" has a 1024 byte value for
> > > > SCRATCH_MNT/testdir/extent_file2
> > > > -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > +attr_nameXXXX: 9fd415c49d67afc4b78fad4055a3a376  -
> > > >  
> > > >  attr_set: Input/output error
> > > > -Could not set "attr_name4" for
> > > > SCRATCH_MNT/testdir/extent_file3
> > > > +Could not set "attr_nameXXXX" for
> > > > SCRATCH_MNT/testdir/extent_file3
> > > >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3':
> > > > Input/output error
> > > > -Attribute "attr_name4" has a 1025 byte value for
> > > > SCRATCH_MNT/testdir/extent_file3
> > > > -Attribute "attr_name2" has a 1024 byte value for
> > > > SCRATCH_MNT/testdir/extent_file3
> > > > -Attribute "attr_name3" has a 1024 byte value for
> > > > SCRATCH_MNT/testdir/extent_file3
> > > > -Attribute "attr_name1" has a 1024 byte value for
> > > > SCRATCH_MNT/testdir/extent_file3
> > > > -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > > > +attr_nameXXXX: a597dc41e4574873516420a7e4e5a3e0  -
> > > >  
> > > >  attr_set: Input/output error
> > > >  Could not set "attr_name2" for
> > > > SCRATCH_MNT/testdir/extent_file4
> > > > 

