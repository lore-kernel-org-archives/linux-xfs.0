Received: from mx0a-0066f901.pphosted.com (mx0a-0066f901.pphosted.com [205.220.160.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534685CB5
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.160.221
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711048042; cv=fail; b=bLI8Ezt8WGercHQ79rDdK0pOLlO8Dl0Yml+0L6t6xeDtO8+2wbJy1UGBthfPJnE841p9paoT12tOIU1ninykmMAQvba3nNfONEkHufUg55sB8bKZHaVyu/c1W0a1YmcbKxsbqs3zawU/8SXuzUkniitQmKqOlKxh5r50gSJt6H4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711048042; c=relaxed/simple;
	bh=dhHYXlcGdpg263d8rP0H3yjJ2a9kpusNTNGeovuaOgg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=km5bC7/pfeLBUNgrZNT29vscfAWtoDeg2hUklkQazavirYAM9khEI7m71bBsAs27bis5qdyj9qbKUsRSsaML1Cd02PAbi8sSQFG5tzH+2df1vO5A5H53hMeueogzRjDV52BvSPLNSxU7eEnpuOR2E9Z1nHWGTRxqmuyytl0guM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kyndryl.com; spf=pass smtp.mailfrom=kyndryl.com; dkim=pass (2048-bit key) header.d=kyndryl.com header.i=@kyndryl.com header.b=ckk5xCFl; arc=fail smtp.client-ip=205.220.160.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kyndryl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kyndryl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kyndryl.com header.i=@kyndryl.com header.b="ckk5xCFl"
Received: from pps.filterd (m0268692.ppops.net [127.0.0.1])
	by mx0b-0066f901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LGZ0JZ012517
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 19:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kyndryl.com; h=from : to : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=dhHYXlcGdpg263d8rP0H3yjJ2a9kpusNTNGeovuaOgg=;
 b=ckk5xCFloStl9bly0RXBArWyXTAIJWz23+BnUd0MT3NfeTDpWVzoT0AADEP05898NCyH
 ZhT2JZY2ScShUiGYlodYsn+qlUFjlbkXJKdtTWe5aNpFtf6/p4Chq0JE7ZyUap+84Z/O
 MImxNyv51pw+RiDIctB7eDgXbAPfz4PjNN/RuNUollyK9BNn4xqhltAe5nMZ/jG21WwE
 5i9NciVRdfEXO81JQYPh3cWHAg7lwk9ms64v2BXo3RbQWNdhND95lChFtl9B3pu0LVVw
 chYJ5VmBHoQ7lukKI4oQGMAJfyFmHe6dkfPoiLWgAb40HM/DpXXVre4h5CRiKosnfDtC cA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0b-0066f901.pphosted.com (PPS) with ESMTPS id 3x0jtqay95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 19:01:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gw030HhMxCRgqtPitbPzLgQwLf1JLxFxA3u1ezXyh3oC2KXbZI7VzXKuTqybNJOVWSvrSkx/4RVQKtBVbY3uIc99AurG4qx44/Tj3uqmIOfLr0LLH5Z49b0up5uwkR1KZKyPHk9CSbBhUpHkUxdvIxp541aMqqhLvlvrDwNTLrSF9z5zdI/3cuISUBVHBtSPF4HyBVFk2NHAneO7qlyazISXL3wdS8MZlcK9cZorpZs4O3Q7LDFmrKxI74DX3HBWeQufiyFmBPo27L9RnDkptaWOYLf45shLh+ica9IILiQ2/HdIBEiHfO8rw0/YLQccL/CoMxiT3NSC7Jb1Qr8HvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dhHYXlcGdpg263d8rP0H3yjJ2a9kpusNTNGeovuaOgg=;
 b=Apf+vi18eMdI4t+RkqjOG9u2dm+qC+fCnQB/q1SzEk5HWvPJh1xJbiV0EYJQ1wGCWOWZnvXvWnAHiHWZOxeI1dBxbD5GRMKZpWYbzd3L7rc132EtqsZpETqHwGJqxDhfcAJUXitMGVa3B2+zEHRkihiNNing8dAyFxxvX9h/MwwvrvPObAkHRETskBgpOkU2iRmAlajgaB5e4722YbVRcG7UEBmYFAt7Zs2AoJnX1Zu/mK0OYundSWfSafRwozqSO3OeiYR9JsIUQ/jUHvFqP6iMVbZo/9vZ6I1E9WSaT7PqPnQhClL2XIvSOApOhCF9soBx2hKQ5SOAF9DiLanJcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kyndryl.com; dmarc=pass action=none header.from=kyndryl.com;
 dkim=pass header.d=kyndryl.com; arc=none
Received: from CY8PR14MB5931.namprd14.prod.outlook.com (2603:10b6:930:61::6)
 by SN7PR14MB5961.namprd14.prod.outlook.com (2603:10b6:806:2a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Thu, 21 Mar
 2024 19:00:59 +0000
Received: from CY8PR14MB5931.namprd14.prod.outlook.com
 ([fe80::71a1:ab4e:d223:e9]) by CY8PR14MB5931.namprd14.prod.outlook.com
 ([fe80::71a1:ab4e:d223:e9%5]) with mapi id 15.20.7386.025; Thu, 21 Mar 2024
 19:00:59 +0000
From: SCOTT FIELDS <Scott.Fields@kyndryl.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: XFS: shrink capability status
Thread-Topic: XFS: shrink capability status
Thread-Index: AQHae8H9RFfIYHoMN06/3k/H8wluCg==
Date: Thu, 21 Mar 2024 19:00:59 +0000
Message-ID: 
 <CY8PR14MB5931A9E3FFDF1984EC556CE48A322@CY8PR14MB5931.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR14MB5931:EE_|SN7PR14MB5961:EE_
x-ms-office365-filtering-correlation-id: 40c5841d-f78e-4830-43df-08dc49d93f04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 zDiilqm15mwgkwxT1c8GQ2ZxotubwJNAuZkZG8gMlSKf495InmwEuRP8maT/VZes8lY9AMRKEW/Pr9ajv5Obx2LUIY4Bglro4JsloFP0NCZr9mMnn4mohFGOF5C+ICeffXSzpaHaxCv8RQrdTL80LDWsJS29857fqJzyHZtpr27noY86m+iP66CVrpd5aO0L5hmZc/wa0yhKjRll786QPrY7xvB/zKJiQz9BStXiAkPQhJG3wQGs8vr060Evd6+Xg2OPAbdL0rZu7ZT7P1DvolJr5C4hIBMCrGdYg3RC+BAwYJIeu+yz3YjPmskXpd0mR9xOEoFSfduLYhZb7xUt8FiscyATj+VSRgUeLGOxMSR37cWf73Lx6lPYLGn/Lk0rObwjOZ1gNkc9odmA3356GqhvKzfsXasSAEP81ERZiwVMB4z8XkGT39CL6Z7uvmQW12HrbSyv20kHuN5NkmNbA99awjuxf0AwJ8VNj9ATKt2kHmm6rKDr3C4EPWLEunuuJxftE9Fd406GBQRbL0sYEhuhdm48afeN4M9gMXHxYQhwsD43ev9oO2lWPE3EGgxLc54Me5pdK5QmsC5rP0XCIf82iwgRpgm2NJQX86gZd68RnfcO8Cx2o0DxsqOdc83gW1zLeo6PkdCd+mZnC8c4A8LDhJ9B/U8OoZ3KMT7ABuqXnuw8XsQl71tes5gU22s1S+qsfa+3R1JIgr38mrG9qB40gFrZaxh25IO7/01uF/0=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR14MB5931.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?5mMmadUawtx0lC/DFRi1lfi5eqSRJel/dS/Socibl0psW+RZAYHYDntIsC?=
 =?iso-8859-1?Q?AULLBQVxoon84aVa/75XjGoz2NfCad7c6nX5tdFyD7HwEqWyTtlANyuwP/?=
 =?iso-8859-1?Q?4Dm3Gy+2CzyfSGFicOgZgkLX32+MECQDoPzGmOHPnDidpDeZl2dn5jypMb?=
 =?iso-8859-1?Q?H9iym2/acDHmVgaeMGlzRKC3jdu3WUPUMOkylyFKgvmmvDfptO69YIi7Ag?=
 =?iso-8859-1?Q?g3BI/2DER5pqPFs8I9FNt1voNauDY0xU2CveYLQQgIOydOxIzImNpGJR6z?=
 =?iso-8859-1?Q?yU+rYQewhom8TsAiUde06eaFCAal4Nyyw2n6sLXzjdRHOT8bK3736728UM?=
 =?iso-8859-1?Q?8CM4QFrLU6Z24fqCZtvGw9pdCoPnkrLqwVQFZ0MldIxkaAz1cfSKhKao6d?=
 =?iso-8859-1?Q?aWYjV6phIffbzmSZ3IGg8MoRv2yCWfkqVQblCu49xc5IMPXQx+j2tOCje4?=
 =?iso-8859-1?Q?2SI7DATJCAjMrU7yErmf+wmt1KD9HAeEG+56ca9tmiBJkZw6VQy/TrWgdW?=
 =?iso-8859-1?Q?+DMwA+hco809qukKIOSzur8y/7xPd+ULLNcXzHjZrzfGzW8l1Xo9BLD94h?=
 =?iso-8859-1?Q?6EF8Xw9MtsOg38hDMPMwbGmjnSidln26UowcjXSdEKSQkbaHWlRq2Blyhz?=
 =?iso-8859-1?Q?5XQHsROAkc4sQFt7UJfXqEvdUIFKimDcBRAZJaQBvHm0x6qSDC48EwBlp8?=
 =?iso-8859-1?Q?m7XQDteumQxF+0l5OzFMrkBNN77Dn3iWR9rswhktlRCGzEX6vhLxfdMGGB?=
 =?iso-8859-1?Q?2Z7bgjHT5ZCrvDQgG5ci+/DMt0IQm5ih3+ta+c8/Ir1aYh/jP/7WgQPaQR?=
 =?iso-8859-1?Q?6kRPUg9weXiyz9FHHaAd8YPoRB9OHiAujhL4BWpdNzlmqID6gzcEMSgWOJ?=
 =?iso-8859-1?Q?TGbeWwiQIVbOcsxg1ItuqJ+O5nHlTl9ygsSIk/3uZAs5glYPzniUIlkDiZ?=
 =?iso-8859-1?Q?dMCnlpOd9bw/mIV4uXR+MAKQqhIjehOwspQ4UzRrWHsINUVkwlw4/rJC7p?=
 =?iso-8859-1?Q?oX2zo74LAoiRNSnTUFCr/v8q3dUsW82caauSkxd2TcfM30n/fkB52GjQ8A?=
 =?iso-8859-1?Q?DeL8m1aDD3mQPtgw/dWEipVsQCarynGmyu/W6JrbLvQkhjBRCvXOogOhMx?=
 =?iso-8859-1?Q?WEIMxWKeU5qG8D4pYlPAZcdvndd/oh7MQPsFaqXPMeV75L7aL0mWREVD0M?=
 =?iso-8859-1?Q?1tSiwjYzfmlFOa3e8E30jAuyPdRoxC29lx3o23qJvIEMnetJBgFX16AcGL?=
 =?iso-8859-1?Q?8gNfsksjvAtDPKmDfF3cGHKCVpe2sFQp4a4dBqTJZoEXCTFD4UjGLfBfNt?=
 =?iso-8859-1?Q?s4GkcYmWlTjX8GIRUoYONFAHC76KafNpF1eCxNG4mkkKGU//G9VXvM9CGE?=
 =?iso-8859-1?Q?KqnYlJU5dlchva1fE5AvZDLX5ycmkbpKhN/JSu7YcGoxfzUO9zpXV52XYk?=
 =?iso-8859-1?Q?qILsuFMW8ozkg49l+gnQSXSY9jQJNHH+HJKNfReoaARqvQRBuRsrq0W6zO?=
 =?iso-8859-1?Q?FCVUpT8P/VV+ug6nZl7xZnBmjfdrXhmWAKVDJL4577ckVcTc+fNBPclOdx?=
 =?iso-8859-1?Q?lrXsIKXvmra0CfaGC9iLxD645zUOh5dsSaQY0NgCuSazExI/1bUrGw9UsL?=
 =?iso-8859-1?Q?OlqD43Vz2j/0WMOLeYjgk4JVvKZxXoDNME?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: kyndryl.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR14MB5931.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c5841d-f78e-4830-43df-08dc49d93f04
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 19:00:59.3681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f260df36-bc43-424c-8f44-c85226657b01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oYKdmpaaZZRt5pgMDBIZOHtEfyJVa3KTzHIXaIQMn8pMMHRnJkjY2RW4/MK7Jiy+VYGoJfIphWx+pxBlaCcCA4Pp48PjICVo0MTrJ3brAMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR14MB5961
X-Proofpoint-ORIG-GUID: vrEAeoxZcwZFlhZrIrJmMSVOeZu1FG4N
X-Proofpoint-GUID: vrEAeoxZcwZFlhZrIrJmMSVOeZu1FG4N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-21_12,2024-03-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=619 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403210139

=0A=
Is there any current line item for working to get XFS filesystem shrink cap=
ability implemented?=0A=
=0A=
With the basis of the Stratus project (Red Hat's solution to ZFS in many wa=
ys) depending on XFS, having the ability to shrink a filesystem is more pre=
ssing...imo.=0A=
=0A=
Scott Fields=0A=
Kyndryl=0A=
Senior Lead SRE=0A=
