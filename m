Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C7AC76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 15:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbjDEP1L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbjDEP1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 11:27:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BAB5B9D
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 08:27:01 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335Cx2SZ013924
        for <linux-xfs@vger.kernel.org>; Wed, 5 Apr 2023 15:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=dEtN/pqkYQH6owFZ5k9Wfe/CwZRxigARRleC4ifC2Mo=;
 b=aWxckgSUQBl0gz/ktlYkYv6HNU3WIiyPEWPXEW4sbwoPaLe50x2dsaraBgk7GBpzzCAp
 l58H3QnEOwbdXn7F2LewGLJ32ibJgidya5jHkslLf/rk6HQK2AGFW00cqhWi2+hHerCY
 EmzQbS1GBdfnn1lhYQDjUxC/aE393pPeaC2YPtuOOfKtKmmgO81baMAp+dUo0v3Nk1S9
 OIBlsM7LFXw8hMBJNpn+fHV6O6+v315JApa/vg57rtyRSwsn3xxnTcwqWREAB/Jqsb7l
 drdB6kIfHrZ9aDhTNawR0V1FCips+KGC1mFQZJUkWr7KMhcmDcKgN2tPy5ZJQ2mSsXad yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcnd0q3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 15:27:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 335F7bjF037726
        for <linux-xfs@vger.kernel.org>; Wed, 5 Apr 2023 15:27:00 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjtsk5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 15:26:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEnFhvsI6DMcZzzBmxtlUMkgopgcbbizG8qRdPWUR10VBpMghVn3JawYSg408IHqA1WpfVcUYEBsfYBt/Bz845061f3nVL5GkNFWaG7u3vDW46/cni/8Mlwf++qhy4foEU11fBCA5LBiuz1/rsfpGepiQBEKfXsMZF3YiHp4lEE4a4HTC7XaEO8+dn4GVzQByAI/vzMTgxJmoF4tIX0UJQ7w+tEi8X/qCmFhc2JGI0USJQcBO310n9eq///kx9es97SifqHheowtnc/QOlYNiB8F5eYSS0+f4NtdKarSSvvL21bQbRePPS0f59PkMoeBTpsJpYdclvJemRNkiG2e2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEtN/pqkYQH6owFZ5k9Wfe/CwZRxigARRleC4ifC2Mo=;
 b=BAt4QUGB7zuYUUujtn8mcx+zKjJJkI3eTlVYXRAsxySnw1Qh06zYuBEP7gcmp4IEnswsUbsaRp/C2Nq/KkUrej2teaT1r0jdvo6KgLpSKlfHYWEHPPdmqPsUen9ARV1rtBb5eRidFdeVz8P8Ka+JU4lu+zDlbcLFXpTU3W1ZOxxT/CLGkmiCUiQxWgCQBK0mMwe/pFsH/OLQdZhabP7XVa53Lqd9X9TRfgSfXPQOefUPB7+cNTVPwo20gaX8y235moGJ8pVyaZ6R9rT6+qY0/bFnitztWR/XAjdKZxUiapPSj+RoB/eUbC4T/lxeu3zPMoZeWYb6DsiGx67JTwT7eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEtN/pqkYQH6owFZ5k9Wfe/CwZRxigARRleC4ifC2Mo=;
 b=jRwv+kYLqEQpfUlbY2pmcecxPdITGr0QwRxh7lIseTY8opqSQ09Dj7vOFKasV8AalnWccH9vsOmkp+yMdt5sMoxLq6N4xMh+CrKCtMcVuwSjYTYIEWpZdMbw6cdpKjA/H75ipmKy7vMtltQ05Su5Fv94XMZX4HIYaPp8iLcJRvw=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SA2PR10MB4475.namprd10.prod.outlook.com (2603:10b6:806:118::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 15:26:58 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::e8ff:d210:8fab:1b00]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::e8ff:d210:8fab:1b00%7]) with mapi id 15.20.6254.034; Wed, 5 Apr 2023
 15:26:58 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Thread-Topic: [PATCH] xfs: fix AGFL allocation dead lock
Thread-Index: AQHZY0iqHX19AiUQVEawS0PTWbztO68c34CA
Date:   Wed, 5 Apr 2023 15:26:58 +0000
Message-ID: <195F9602-8A3F-4393-A48F-33122226C25A@oracle.com>
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
In-Reply-To: <20230330204610.23546-1-wen.gang.wang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|SA2PR10MB4475:EE_
x-ms-office365-filtering-correlation-id: 0e468eb6-439e-461b-a368-08db35ea3211
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zguie57o/oHbdVrC5M2LuMbYIpgdUL2/kwrwL7iNwNWMhIwcOw+R3xWpNcPLiSBegL54QybAR5829vGPLGCnDu26uW1feYRvsVdBzIFaS98GjLjPK3CWBI2c1taG/hR7VbLc4gZI6KFZFojO7nkTkIkQReKRMjwKJvVASErisLEGlfhR7CO1kJ27CjfmBbdQC8YB+Z50eC5/dApifluSh6avmJzGXDE8w6plpuZR/YZSWe/UGpGnun0fK2HQSgiqDrtKig+h+r0rX1/EU+ZYM8iwhg0TquBiROpKbmXxbEyTSQnoh0QWBBvJZGB5C91YOAqRJFgN1kTXrWJoBI6oHPFEBFPeVyhZDS5+1Twa0YDHnL58ChlrBlnTfyuTRpkMrPNBzBBYsBqQ4HJjMuuxo8C5KMUaDHWzkMCBLVgnTE9VWTJ773D9K3Czi3hEhAxbqxGYykEyhnyWj+Guk1Kqr+lkgTwoOldJB2vfTinVErZhAzRXEPgBFrk+cmmOTqsvydRIaqEBdXmkx85FgSUKblCBisMiXhGBScF0kKMsAdvzEIeJGfX1zfQZyFymstisE8+gz8dVPWybvxn5ClyszvACNPbanzno06Sngtu1uDCP8TBuNr+5nkyPwdEhOcJIanjkVL/inPCYkmye1hDGA9oXfEIYPvzVH0lQYjEfIWURegs3VgBUKLadtn/EUdxz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199021)(53546011)(6506007)(6512007)(186003)(83380400001)(2616005)(6486002)(71200400001)(86362001)(122000001)(8936002)(41300700001)(38100700002)(36756003)(76116006)(5660300002)(478600001)(66476007)(38070700005)(64756008)(66556008)(66446008)(66946007)(8676002)(6916009)(2906002)(33656002)(316002)(46800400005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a0+jEbGKlevxrk8DZuOrMvfo/7BC0zJloEfdiJoR+f7X7omW2gglpbOpxB+O?=
 =?us-ascii?Q?Z1VPuh+WuvK5s0uORX6eThhRHZMnUjsHTSx/FnAAD9Pxd5pgjsohPcI7nJQQ?=
 =?us-ascii?Q?EAGEnm7VxhQ9075+w1VMLxF+MmNfFyMhg6TqC2OGjs8HbZxtE3rBSmx6LY6V?=
 =?us-ascii?Q?CFBjEw0osNWjCYlhzfDlV5lG+S9YA0h8aLfGJlFhqFcd335M2p87u6aV9XbH?=
 =?us-ascii?Q?NbWkOtFP8+9F0045DcAad34UqWm0RP5Di/4Dz9mlryP3HQfsVS6EYLl9diLJ?=
 =?us-ascii?Q?+7pSRt3M8qMWbVGDgZITMnCxZfZzlnPZ7qFDPmx//+h790bj+y1tQ0+yEgNf?=
 =?us-ascii?Q?MWmM3m5lbd4OHl4Ifzb+ohQ0mUaLLJnUkCxLF7GJdImU7fpW08/j8SXkKsPC?=
 =?us-ascii?Q?ZGX4gRkrZUueR8KmUCyNeFxJVzruy7TPVEEfLuqLJVZsMxH8z3Wvzbvn2xZ4?=
 =?us-ascii?Q?xksU+Vq4is+FD6pbE625WvZeZrc4uEDMNTyh9gUVjnAfn4KRfVnVaHPnE60J?=
 =?us-ascii?Q?aVQs1COzh+QswThKbxDkuXcuNTzOEgv2iPyDxcEoyCAhKZqxBj8ORQanh4/v?=
 =?us-ascii?Q?Zv3WyxSIzdChKmwmKcfu28eMSju7P8bpOc73OaYT9xVFyfBENIBKD/At7+9b?=
 =?us-ascii?Q?OtvyWwar18vQKzUqG4IzKVj6jALYYD0VVy0Oqr43/Y0VpiUzYFFuRrrbowAW?=
 =?us-ascii?Q?CgLuVvkoL5PwV7aDJotxUEjz8oaWNBDHtZ1TeFdiTpfgnqQvzJkdsYCVX/cI?=
 =?us-ascii?Q?IxS0e6iU6M/J3m+2qi+ePltnWCDaVl30kYu4EpK/sWNNyzUmWZ2xmKYdqOL3?=
 =?us-ascii?Q?HzSBF+HtTTJd7k0SBUhIzinWs5bibYX2IacW6forB/Ci/WiK1+cIrVxN+YHN?=
 =?us-ascii?Q?IBfPyJtjNvcSS9Y06yIA6clxbZhjnckqo4ofG5eu+0AOGZahfsj7rz9QxWkq?=
 =?us-ascii?Q?GDyXIMnf9S/22VyTasX39wG8rSra9SxdivK27RetWKM82ZT8hzqUYdDYOYZn?=
 =?us-ascii?Q?juqhcAnflMp4wRa7vRgIOr3A07X75LCtFllUiH0diEAx1HTosWsnZ+5RO+rV?=
 =?us-ascii?Q?bHOHAj3u9ZKeCdWKnOOKXmtZQxfTZmodYYCFYmX7RihbSoHIOlrpbsW1e7+8?=
 =?us-ascii?Q?rqnEqO+m70y8mqhwinPPGPjaQsH9DnC/+r4HBo3dINrzeEw9pbWEOJBzDBvG?=
 =?us-ascii?Q?gDz6QGVSTMhePs50t1yOEjmW4eZg9qQnhIxWwDTCmEQty1z5eYoX0mo6BlxA?=
 =?us-ascii?Q?cVtJGeMK3C3kk8yewgxFOgv7ormW3iAsRJ1qF642EEA2lHdwsHC0J0l0mdKP?=
 =?us-ascii?Q?2wc0k7jJf9PU1WYUeVD3XPen0iGVmAsk0srmrjzyrFvsitOA2ViBqvTEdcLW?=
 =?us-ascii?Q?UOsmeGKQIKp1dAP7zhxpKzX/c5/kvFX2rN1+8NO9XFljN1827+Gtk4thzYGJ?=
 =?us-ascii?Q?L0klG+yRp9+vKzLW4PS+lC7jEMfSC+fBLasp+hyKyMdZz4vm4WhG1mviROYw?=
 =?us-ascii?Q?4ff5CYnA+ZCMirzqr6ycvy2CRZX5Qx29fYTgu7oHlhfq2t7xigKjR1ya5G/e?=
 =?us-ascii?Q?kpspuNvpIeWaDtNyYgZ/DMaO0QSWdp5x6tSEqTME+GZMU70iqzCM1IJg8P0R?=
 =?us-ascii?Q?4VgzR1k+nJ2VtK26E5ojqpA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <301076A4C34486448FDE6E1BFE2CE86F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0QBv5t812iBTtV96CvKd7YB2QOgQRSuihBARIOL3umKHk67wst9nGXoe+fbb1PBPmynySv9G/r+TVkxR6oa33dxf7mdzozlD22ISJuV4CRX1xQjRfp4MSyeICCl3ALRdlrnGtS4ICrJUeCKygP1CXM5sW38B/cZ49hebW/lkRZlqno18Mqg+1amU1l9G4XMdTejlyS1Vwaw+ZuU021z+cQg8xH3IoOQVTwy2UacbKVMiFPyq53BBrnhSHMLB/vTXlDAMgQqNj/qEiPTFXQwBp7hLDV0M6Ku8IYajiJidecUs4vbuKNI1YLvk5Sd2qM+Oio5Mn7w2AtIyoOFIwMPjaERiIFH97/MyGJ8w9u1wj7mNYCSr9uw7pg8rg2foJY3c7sMr9WnwMfAvGyDmh0RGkHMfFgd9nHYhlr1NkEctHwR6eJW7RzHJJAo1oty+V7YqWxyD3uecZMf0qOO15pEGfT5fI/tPIWR3ithRF/Tf7Yh76J4Nz02bVxYd0yQDmJXQ9jKw34H/EjKJwF5hrwRdnC/nkQPRawkFJKDyFmIIf7haNGtkdwMz1GlbBJcB6djVG1qA5xnvhxMt0MMs+jNgJkKjLuSCAVm8Wh5IsFr96tQ8YUX4FkKrO0RszxMzAUfRnUHthN1B4E6u1riPJd/93NJ9T6G2VWWhR42WqzDB8/+gKo9OL3AvjEIDTdUwLqC0agX59fFw+Si5rmj2XZ5Wa3iXIbyWJobpzSCgHlNKmvsESfH55DQqPbdAAXgX6saL
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e468eb6-439e-461b-a368-08db35ea3211
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 15:26:58.1191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lJxtjxanscKzhO8EynCSP89pjH3scjmb6VZssudLyZpQ5RYnCiwW2T6xpo9WJ0B6ZyuY17C3yLe1717ZwjnXipD5gyhTYAZb+7t17xToIX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_09,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050140
X-Proofpoint-GUID: UOYAnkYp9S2LuZhM_9Hawa2Lbq_m7YaT
X-Proofpoint-ORIG-GUID: UOYAnkYp9S2LuZhM_9Hawa2Lbq_m7YaT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, Anyone please look at this patch?

thanks,
wengang

> On Mar 30, 2023, at 1:46 PM, Wengang Wang <wen.gang.wang@oracle.com> wrot=
e:
>=20
> There is deadlock with calltrace on process 10133:
>=20
> PID 10133 not sceduled for 4403385ms (was on CPU[10])
> 	#0	context_switch() kernel/sched/core.c:3881
> 	#1	__schedule() kernel/sched/core.c:5111
> 	#2	schedule() kernel/sched/core.c:5186
> 	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> 	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> 	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> 	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> 	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> 	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> 	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> 	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> 	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> 	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> 	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> 	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> 	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
> 	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> 	#17	mount_bdev() fs/super.c:1417
> 	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
> 	#19	legacy_get_tree() fs/fs_context.c:647
> 	#20	vfs_get_tree() fs/super.c:1547
> 	#21	do_new_mount() fs/namespace.c:2843
> 	#22	do_mount() fs/namespace.c:3163
> 	#23	ksys_mount() fs/namespace.c:3372
> 	#24	__do_sys_mount() fs/namespace.c:3386
> 	#25	__se_sys_mount() fs/namespace.c:3383
> 	#26	__x64_sys_mount() fs/namespace.c:3383
> 	#27	do_syscall_64() arch/x86/entry/common.c:296
> 	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
>=20
> It's waiting xfs_perag.pagb_gen to increase (busy extent clearing happen)=
.
> From the vmcore, it's waiting on AG 1. And the ONLY busy extent for AG 1 =
is
> with the transaction (in xfs_trans.t_busy) for process 10133. That busy e=
xtent
> is created in a previous EFI with the same transaction. Process 10133 is
> waiting, it has no change to commit that that transaction. So busy extent
> clearing can't happen and pagb_gen remain unchanged. So dead lock formed.
>=20
> commit 06058bc40534530e617e5623775c53bb24f032cb disallowed using busy ext=
ents
> for any path that calls xfs_extent_busy_trim(). That looks over-killing.
> For AGFL block allocation, it just use the first extent that satisfies, i=
t won't
> try another extent for choose a "better" one. So it's safe to reuse busy =
extent
> for AGFL.
>=20
> To fix above dead lock, this patch allows reusing busy extent for AGFL.
>=20
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> fs/xfs/xfs_extent_busy.c | 15 +++++++++++++++
> 1 file changed, 15 insertions(+)
>=20
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ef17c1f6db32..f857a5759506 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -344,6 +344,7 @@ xfs_extent_busy_trim(
> 	ASSERT(*len > 0);
>=20
> 	spin_lock(&args->pag->pagb_lock);
> +restart:
> 	fbno =3D *bno;
> 	flen =3D *len;
> 	rbp =3D args->pag->pagb_tree.rb_node;
> @@ -362,6 +363,20 @@ xfs_extent_busy_trim(
> 			continue;
> 		}
>=20
> +		/*
> +		 * AGFL reserving (metadata) is just using the first-
> +		 * fit extent, there is no optimization that tries further
> +		 * extents. So it's safe to reuse the busy extent and safe
> +		 * to update the busy extent.
> +		 * Reuse for AGFL even busy extent being discarded.
> +		 */
> +		if (args->resv =3D=3D XFS_AG_RESV_AGFL) {
> +			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
> +				busyp, fbno, flen, false))
> +				goto restart;
> +			continue;
> +		}
> +
> 		if (bbno <=3D fbno) {
> 			/* start overlap */
>=20
> --=20
> 2.21.0 (Apple Git-122.2)
>=20

