Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA52C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 15:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351372AbiCXPpl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 11:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344411AbiCXPpk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 11:45:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829812A72D;
        Thu, 24 Mar 2022 08:44:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22OEsETq024586;
        Thu, 24 Mar 2022 15:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3BIAfvPWyEfCK+LF/wgqjKL6r1s8zLBkHRqIT1CUT/A=;
 b=bTs0/K7G12dDmFgugayPoNF8qmFwm9FnWKUsfr6dlrmN7lH1uQPTIjhkSIEVNP7FpKfz
 htlXvEtnq58+t7kYgj8OBT//2fNKyoBZBvi3GxLlv1EU2qbK7A/6GkkQvYhzi9n0QLGT
 HroruQMsMFwg86FFoRSOQMIHna0VoBZNY6Cf65RnFUMZz4Q1zC/o51t0QlKdrRX4xTak
 QT3GXfQR/xcv9aKciK/oRyv0f5yWmlYbRw8wd4gWlqgOoXu7vIadxn/xyW5oKcmCJ64m
 Pxdn0qZS8poKbpOdGl2lV/qvYQuMKMHYUEozXL5L5DRt/lzWoElIr8MjSH1BAw1fRcJp Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0vx6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 15:44:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22OFbWUX154757;
        Thu, 24 Mar 2022 15:44:03 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by userp3020.oracle.com with ESMTP id 3exawjdmd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 15:44:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BC5elj2NHXAMro31BmJU/udh/5eLxSUErVTmr7JucrLG/a1cDTCt1AU9u6NzdW3FzkgWxZnQEjg7KSow+05HCrdr9JEgr80G407l49i72FcJJp+DF6tYTcQCIgy+Kzq4vPkDx03TUJUDAUJIS3z3WNf/4b1y6xctodbY8sOSepFtq6a0vi6JB40akhhzbk9OEjN+FG003bD5tLiEMx60moV7FhE1SMTTG6nJ+BC4mujRDgNCXibHX/19luKazGAQDZKJv+FhSIaJ4hQbRu6ov+edrOh9yS1DflwA+OtUwqKteUhq76V8eaUT507ZJHFOSGwIye5VXXyDfbJbtcOe+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3BIAfvPWyEfCK+LF/wgqjKL6r1s8zLBkHRqIT1CUT/A=;
 b=AgEt2goYDnTj8itpW75BRdOBueDn13a/c08B6h83xMGmSVY6RNAmDbKWi1WhoaipMeuUl5INve9UlJUY0tYn/06b1txyR48VngnzJ2fXd4gojGZI435SQJOu7l2VI1x3o9GBag5NodKllGZeFj1stQdMRynxCvOAwsIhK+7ox0Lfz3WmDb8Z5nmcyL7VWHNqYuAvXp/JOUNtcyLRtFc7JIixGSddjEHUnj4fHJc6NWP+iTAmzeWtIkEpqzKnP9GjzDzJ3dwvz7ipfHat2fJjM9oFMPsbaaso7TkZ8Sc1TduqjFW7OnjAVcTLEzEVA9uDLZL9dFxwDDkQZw9r1rOa1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BIAfvPWyEfCK+LF/wgqjKL6r1s8zLBkHRqIT1CUT/A=;
 b=HTIrI9W6jgVNlMgsHEhE28qoY9gs6TKahnMDyT9QvcWGL9jLb67wG21sdCMwmogNYv9a06/nbAuuz9EadUDT7ALvdM6g0bGoRQiZIp4zd3MG83/0xvvSiyT07/e+mPwzvmIuod40Hh+ulkM4xXGHIurTp6/zoHpEH3yCKN7fL38=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MWHPR10MB1311.namprd10.prod.outlook.com (2603:10b6:300:20::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Thu, 24 Mar
 2022 15:44:00 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::35c4:db64:d381:94cf]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::35c4:db64:d381:94cf%6]) with mapi id 15.20.5102.016; Thu, 24 Mar 2022
 15:44:00 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v1] xfs/019: extend protofile test
Thread-Topic: [PATCH v1] xfs/019: extend protofile test
Thread-Index: AQHYP5X7Vko7W7qgi0WTh47GSkH8BA==
Date:   Thu, 24 Mar 2022 15:44:00 +0000
Message-ID: <641873A3-0E40-4099-9804-35D1D6792CFA@oracle.com>
References: <20220317232408.202636-1-catherine.hoang@oracle.com>
 <20220323013653.46d432ybh2zpdhhs@zlang-mailbox>
In-Reply-To: <20220323013653.46d432ybh2zpdhhs@zlang-mailbox>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bed7107-6b64-4435-7f6b-08da0dad1d92
x-ms-traffictypediagnostic: MWHPR10MB1311:EE_
x-microsoft-antispam-prvs: <MWHPR10MB131170EF08441D24DFC605A689199@MWHPR10MB1311.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e7aklg3FZPtVCSS8xw44nUiqRugvs/9tDWIPFvJ57Im74CsNo1XxOmBvx6P+aLaNWl5JkTimszao4hZqOct6XQGRycrIkHIaoyVuTUCk5C+cBn0MBwookSjlOW3KtbyGQxVc03GpbM/sQsVghQLRnuAc+PIr/sA8mx40N/vzjMhS7mbIih4/RpNqjxTDDbwLIKErKc9bl11r/RZajLGaZka5AwZy5xWSEBOSu3cKuVbsbfL0fIn87bdxcenGWRz8ZAMQYrjZafV199xpGE7w/ONTNIDok4T80ZyC1Cy2rlNI4q+a37ZIaARo9lgEw54CWPCpkzx/iwBGOzjunkqHxYvgGsIw7CNbgT3SovLnmv2xrAhxdI7jbmjncvN5gTaUQz3av1oPVWsTYId42Jo91Eh3kiiDAY9P/ZODb3U2Xke4t3TQ0HbZpkt5KQ6P6dlhPQjgpaeAGLtZMIWffQ1GySlW5t7tTBVFNd0/aFmxMAq8YVzGivDu9qiKBX9VEanQcYmFH+tdn08hsO8B2MkGBbAxV8p6znQP9q/VdqNV4MjfWvDOJBH7JEKk3abTPuseek1RsSJW395OmDC+6YnyOU8wkk9droK9g0ylUkQViQSjO6jO7bE2IPyYWGy/VVn1ZVN9ZnmLSIcgWZuD3dEUEvMDmitol3xXsXAh7lWtOQXUp+rfJGjAf2PatOpjPCIkXfbdrFIl0Fv4itYaOhIs04EyFWi6pvwrV/e2b/pzLpk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38070700005)(83380400001)(122000001)(86362001)(91956017)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(36756003)(8676002)(5660300002)(4326008)(6916009)(54906003)(44832011)(8936002)(2906002)(316002)(53546011)(6506007)(6512007)(33656002)(186003)(2616005)(508600001)(6486002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TENMVXQ1aVFrZkFLbUxqcC93dnowN2Jtb2c0d00rcGlvcjZ4NEtIcG9zb1BH?=
 =?utf-8?B?VDA3a3VnOVV1UEFSNzdnditBeTJld3dSaDhnYWtyZmlPeHl0TE9VQUd5cytU?=
 =?utf-8?B?c29xTmNqSkRSRnVyQXZBL2VFc1VhVGJLQzRMYVN3bHk0RVprNjFUc2VQeXY1?=
 =?utf-8?B?OHZUS2FJZVhQSmtWcHhzMGJ6Q1hKY05mWk13bXpFdU1RZUNtK2NMYzF0Y3Vw?=
 =?utf-8?B?YzhnTXhqQk5TVVY3ZXUybSszNWJ2cmNHNmVRSXpFNmpjSjA4Z28zUzFFc1Bu?=
 =?utf-8?B?U25UVitHd1BhYjQzVG00blhwYzlvWFBGblZhcHo1YXFrY1YxR3hHNEhwUDR2?=
 =?utf-8?B?WG5IMHBCaUt4QmRZdjd2MzdpejdSSEZ3U3FQeU9TLzdOWlZKSjd6V2dxZ1da?=
 =?utf-8?B?a0MveHRrQlpQMWtJbHFXSWpwODIrVVVDcVd3V2dMamZNakliZU0xaS9sUXht?=
 =?utf-8?B?WWlkL01WTG9UVlFnazI0MzIxbWNobDJjY2ZBMkxoMnh3N0kzWjRYK0FJWHhu?=
 =?utf-8?B?SUt2RU0xcDFNd1RPcjV0aGtScUZUWkRXOVlkTldON2Z3RWhqdGZEeTJycFg3?=
 =?utf-8?B?SENkRDk2NkhrRUluK0VSbUF6SGFJcFFjUFRkcmk1aWhOUlBlMkMrZzRSZHd4?=
 =?utf-8?B?MVJpT09MeGJEWXJpVDIwbGUxNFFuZnJqREtTMThTaHlON3NhQTN6Z1ZoVGh4?=
 =?utf-8?B?blVhWXhIaVBTSFkyUzlraUZMcVQ3Z2MrY285ZXU4aE55ZXNVbjM4WTJITGlM?=
 =?utf-8?B?UVVZZGZsMC8vWE5MWElsTWtjMkpjakIxUWx1Nm0yOFFlekt6Vi9KSWZ2Mk11?=
 =?utf-8?B?TUtBRTBFMHpOcnFUZng0T1hjdjFnSFBIQ1hOSFE0blV1aFRnSUhOQ3VxY0NP?=
 =?utf-8?B?cFFMSlZpeXFNcHVPcC9QOUF4VDRGcEZhVE42dlBLeUo3dzVuTERxOThNWHRG?=
 =?utf-8?B?eU5ISStlZ0FPQ1dRKzVFV0xKS2dxbm5aYlhBbFdBOTZXbEJ1aFh6eWN3QXJP?=
 =?utf-8?B?TUxPSWhIcnZrdTdEckV4WnI2U2FqTEVFTkwyUHcyNkZsVUs5VmxmSkZpYjZK?=
 =?utf-8?B?Yk82REdXZlpNcitrUlovQkV6dnY0R21VOVltVmd0NnlRUzdvSXJ5Um9yWmN2?=
 =?utf-8?B?WnpZUUU1SlFoaVVJbjRud3A3VTg1QmdSeTRPYVh0U1lyaS9VTmtzcUFCWEIr?=
 =?utf-8?B?d2lLWDNhTzdUU0RrbUw0cWlkM2ZKZzB2Z1JUSWZuMjBVNXFLbElzZXdESkgx?=
 =?utf-8?B?NThsMXZLZ0Nyai9RODhUSEUrWkM2WHk3ZkY5TmQ3cExRdmh0Y1Z3bEt0eG9q?=
 =?utf-8?B?bjBFS3RiRnY0b20ya1lLU2tVSmhtdWt1OCt4eDIxNmlPckdaT09uZXlmZHVM?=
 =?utf-8?B?ZVhGY1pEQnd1MEVVVWVTcGNlZWpuZ2RwS0JDWGg0Q2E4V0piVVZteUJTTlEr?=
 =?utf-8?B?NDRPS3lZTGJOLysvUWs0WmxnZEFuL3NDUVNUbXd1YTUrYzN0SnpiUTF6YUdv?=
 =?utf-8?B?MS9iTS9TcTZNend2clRFeWQ4ZWZ1ZFJTcGdDVlJycnFJVkg0REhNK2YzclhZ?=
 =?utf-8?B?TFM1U1EyU1BESzUvUWFyUEt1YlVqVEtRWVduc0xIVTRwb2FDRWJHZWU4Vklr?=
 =?utf-8?B?VzF2MlBvOFhPQTNSYStaUFBRK1dRYUYvNDBQVkJCd2MxMWt2OThMZTNPWWFZ?=
 =?utf-8?B?aUpBVzI1NHpmVTZwWllSaTZGNGxVcTVoVXp1RTZzaHV1TWFPNjdsYXZiWVlG?=
 =?utf-8?B?ZXpNM29PUnFXVktYSjJwRTYvTjM4UUY5dmlyTDhpN1pVUTloQlVmUHRrREw5?=
 =?utf-8?B?SHBXYWszVTh4REEzV0I2bmpia3Nyd1VFSWQ1b0dCM2MvbFhPbGVZdWhpc0Yr?=
 =?utf-8?B?ZythNW5YRDVlb3dVUzJYVWpkVU9WaVJxdXRnSHlYQi9wN2Ezb2xvYVBCMURU?=
 =?utf-8?B?ckh2VzVWSFpVL1g4YVY4bjYvWHdGVTZRUWtrLzdKYWRBam9mNkE3UHMyNk1k?=
 =?utf-8?B?eXowbFVxZnBTZXFQN0pYYXRITmtaZmM2OG5ZcmhwTHJ0TXdYU0xMZmtQNkFl?=
 =?utf-8?B?dzhaOTRNT1o5dHl1d0F6WjNjR0RwajZNRXc5TDRXOU9iQlh4SmxZaW1DUFBJ?=
 =?utf-8?B?UVlzUWFNTnB4QkxkUkllRWI0eHhzV052TkVoQU1rWTB3TE1kamxYZ2w2M0pM?=
 =?utf-8?B?ZW9pUjBMQnFGTzZ3V241cFc4RnJwQkZCN05STlpNT3V2eUh6Q0F4VXl1V3ln?=
 =?utf-8?B?ZUMrc2pGNVFnVEdHNi9CaU1Lako3dWF6RWt3TG5salBUL1pGcm0rWUhvdFNs?=
 =?utf-8?B?TXhDYXpNemR0QVpZVkJNSmg4WVhFTVcwM25XY2JLNjFNKzZmdStJN2tnc3Zw?=
 =?utf-8?Q?7d9jbS4Bg+t/yRGLdwQqYMSWgG4Hfsv0gc2YsVq0rHKAX?=
x-ms-exchange-antispam-messagedata-1: B8uYjBPpHKFUS7YZwGcazV9zq+boFmSbPUM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52419B8717B83947AA6188A0F7A08CAE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bed7107-6b64-4435-7f6b-08da0dad1d92
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 15:44:00.2208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FQ69QceAZKEvtYzu3gU8C0TKXvxKa0zjqcUSHD5q4gQrCaApaK04zQvxr7qJaz4h7BijFvxgjPOhoNfg3zeWhMU54JEIcuvZsAjzDnXmPmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1311
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203240087
X-Proofpoint-GUID: mO8lkqkiAW8RSlHo-npbBffHwehfGB9k
X-Proofpoint-ORIG-GUID: mO8lkqkiAW8RSlHo-npbBffHwehfGB9k
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBNYXIgMjIsIDIwMjIsIGF0IDY6MzYgUE0sIFpvcnJvIExhbmcgPHpsYW5nQHJlZGhhdC5j
b20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBNYXIgMTcsIDIwMjIgYXQgMTE6MjQ6MDhQTSArMDAw
MCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4gVGhpcyB0ZXN0IGNyZWF0ZXMgYW4geGZzIGZp
bGVzeXN0ZW0gYW5kIHZlcmlmaWVzIHRoYXQgdGhlIGZpbGVzeXN0ZW0NCj4+IG1hdGNoZXMgd2hh
dCBpcyBzcGVjaWZpZWQgYnkgdGhlIHByb3RvZmlsZS4NCj4+IA0KPj4gVGhpcyBwYXRjaCBleHRl
bmRzIHRoZSBjdXJyZW50IHRlc3QgdG8gY2hlY2sgdGhhdCBhIHByb3RvZmlsZSBjYW4gc3BlY2lm
eQ0KPj4gc2V0Z2lkIG1vZGUgb24gZGlyZWN0b3JpZXMuIEFsc28sIGNoZWNrIHRoYXQgdGhlIGNy
ZWF0ZWQgc3ltbGluayBpc27igJl0DQo+PiBicm9rZW4uDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6
IENhdGhlcmluZSBIb2FuZyA8Y2F0aGVyaW5lLmhvYW5nQG9yYWNsZS5jb20+DQo+PiAtLS0NCj4g
DQo+IEFueSBzcGVjaWZpYyByZWFzb24gdG8gYWRkIHRoaXMgdGVzdD8gTGlrZXMgdW5jb3Zlcmlu
ZyBzb21lIG9uZSBrbm93bg0KPiBidWcvZml4Pw0KPiANCj4gVGhhbmtzLA0KPiBab3Jybw0KDQpI
aSBab3JybywNCg0KV2XigJl2ZSBiZWVuIGV4cGxvcmluZyBhbHRlcm5hdGUgdXNlcyBmb3IgcHJv
dG9maWxlcyBhbmQgbm90aWNlZCBhIGZldyBob2xlcw0KaW4gdGhlIHRlc3RpbmcuDQoNClRoYW5r
cywNCkNhdGhlcmluZQ0KPiANCj4+IHRlc3RzL3hmcy8wMTkgICAgIHwgIDYgKysrKysrDQo+PiB0
ZXN0cy94ZnMvMDE5Lm91dCB8IDEyICsrKysrKysrKysrLQ0KPj4gMiBmaWxlcyBjaGFuZ2VkLCAx
NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS90ZXN0
cy94ZnMvMDE5IGIvdGVzdHMveGZzLzAxOQ0KPj4gaW5kZXggM2RmZDU0MDguLjUzNWI3YWYxIDEw
MDc1NQ0KPj4gLS0tIGEvdGVzdHMveGZzLzAxOQ0KPj4gKysrIGIvdGVzdHMveGZzLzAxOQ0KPj4g
QEAgLTczLDYgKzczLDEwIEBAICQNCj4+IHNldHVpZCAtdS02NjYgMCAwICR0ZW1wZmlsZQ0KPj4g
c2V0Z2lkIC0tZzY2NiAwIDAgJHRlbXBmaWxlDQo+PiBzZXR1Z2lkIC11ZzY2NiAwIDAgJHRlbXBm
aWxlDQo+PiArZGlyZWN0b3J5X3NldGdpZCBkLWc3NTUgMyAyDQo+PiArZmlsZV94eHh4eHh4eHh4
eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4XzUgLS0tNzU1IDMgMSAkdGVtcGZpbGUN
Cj4+ICskDQo+PiArOiBiYWNrIGluIHRoZSByb290DQo+PiBibG9ja19kZXZpY2UgYi0tMDEyIDMg
MSAxNjEgMTYyIA0KPj4gY2hhcl9kZXZpY2UgYy0tMzQ1IDMgMSAxNzcgMTc4DQo+PiBwaXBlIHAt
LTY3MCAwIDANCj4+IEBAIC0xMTQsNiArMTE4LDggQEAgX3ZlcmlmeV9mcygpDQo+PiAJCXwgeGFy
Z3MgJGhlcmUvc3JjL2xzdGF0NjQgfCBfZmlsdGVyX3N0YXQpDQo+PiAJZGlmZiAtcSAkU0NSQVRD
SF9NTlQvYmlnZmlsZSAkdGVtcGZpbGUuMiBcDQo+PiAJCXx8IF9mYWlsICJiaWdmaWxlIGNvcnJ1
cHRlZCINCj4+ICsJZGlmZiAtcSAkU0NSQVRDSF9NTlQvc3ltbGluayAkdGVtcGZpbGUuMiBcDQo+
PiArCQl8fCBfZmFpbCAic3ltbGluayBicm9rZW4iDQo+PiANCj4+IAllY2hvICIqKiogdW5tb3Vu
dCBGUyINCj4+IAlfZnVsbCAidW1vdW50Ig0KPj4gZGlmZiAtLWdpdCBhL3Rlc3RzL3hmcy8wMTku
b3V0IGIvdGVzdHMveGZzLzAxOS5vdXQNCj4+IGluZGV4IDE5NjE0ZDlkLi44NTg0ZjU5MyAxMDA2
NDQNCj4+IC0tLSBhL3Rlc3RzL3hmcy8wMTkub3V0DQo+PiArKysgYi90ZXN0cy94ZnMvMDE5Lm91
dA0KPj4gQEAgLTcsNyArNyw3IEBAIFdyb3RlIDIwNDguMDBLYiAodmFsdWUgMHgyYykNCj4+ICBG
aWxlOiAiLiINCj4+ICBTaXplOiA8RFNJWkU+IEZpbGV0eXBlOiBEaXJlY3RvcnkNCj4+ICBNb2Rl
OiAoMDc3Ny9kcnd4cnd4cnd4KSBVaWQ6ICgzKSBHaWQ6ICgxKQ0KPj4gLURldmljZTogPERFVklD
RT4gSW5vZGU6IDxJTk9ERT4gTGlua3M6IDMgDQo+PiArRGV2aWNlOiA8REVWSUNFPiBJbm9kZTog
PElOT0RFPiBMaW5rczogNCANCj4+IA0KPj4gIEZpbGU6ICIuL2JpZ2ZpbGUiDQo+PiAgU2l6ZTog
MjA5NzE1MiBGaWxldHlwZTogUmVndWxhciBGaWxlDQo+PiBAQCAtNTQsNiArNTQsMTYgQEAgRGV2
aWNlOiA8REVWSUNFPiBJbm9kZTogPElOT0RFPiBMaW5rczogMQ0KPj4gIE1vZGU6ICgwNzU1Ly1y
d3hyLXhyLXgpIFVpZDogKDMpIEdpZDogKDEpDQo+PiBEZXZpY2U6IDxERVZJQ0U+IElub2RlOiA8
SU5PREU+IExpbmtzOiAxIA0KPj4gDQo+PiArIEZpbGU6ICIuL2RpcmVjdG9yeV9zZXRnaWQiDQo+
PiArIFNpemU6IDxEU0laRT4gRmlsZXR5cGU6IERpcmVjdG9yeQ0KPj4gKyBNb2RlOiAoMjc1NS9k
cnd4ci1zci14KSBVaWQ6ICgzKSBHaWQ6ICgyKQ0KPj4gK0RldmljZTogPERFVklDRT4gSW5vZGU6
IDxJTk9ERT4gTGlua3M6IDIgDQo+PiArDQo+PiArIEZpbGU6ICIuL2RpcmVjdG9yeV9zZXRnaWQv
ZmlsZV94eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4XzUiDQo+PiAr
IFNpemU6IDUgRmlsZXR5cGU6IFJlZ3VsYXIgRmlsZQ0KPj4gKyBNb2RlOiAoMDc1NS8tcnd4ci14
ci14KSBVaWQ6ICgzKSBHaWQ6ICgyKQ0KPj4gK0RldmljZTogPERFVklDRT4gSW5vZGU6IDxJTk9E
RT4gTGlua3M6IDEgDQo+PiArDQo+PiAgRmlsZTogIi4vcGlwZSINCj4+ICBTaXplOiAwIEZpbGV0
eXBlOiBGaWZvIEZpbGUNCj4+ICBNb2RlOiAoMDY3MC9mcnctcnd4LS0tKSBVaWQ6ICgwKSBHaWQ6
ICgwKQ0KPj4gLS0gDQo+PiAyLjI1LjENCj4+IA0KPiANCg0K
