Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0612E9443;
	Sun, 19 Jul 2026 08:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784448999; cv=fail; b=iEsv6rHV/DcFaFDecYFuhckzkhXcNw3oddGhW1qJuYIDnE/RSKmmrATHn4rp5os3Gd7+3Cc7VJEB7ZoyVrsrc2nKGOnXahFheur96989D9Wf54EXvIethK2X61nT4Z3PupEk3H0aSJ9oenGxZi0HZmB1UXJTAuDGmDbXOoAlhGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784448999; c=relaxed/simple;
	bh=EW2UbSojXBwT+EJICSOzoXYA6+oI9eOxj59COlLMqnw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FS3TKA4+rw5JLqzRrrXBUl7bupg0L9piqskwkFeaoMw3k0Ldt+J8AwQgEz6I1kUKjT+NS81VMkGnYgFKoex1t8Ea9C9azJn/gl/s4IkwjInpWWC/49kSVju73G6thpavWZ5dD4WaLU9wsQS9C3WoFnINBL4PwEulXvWMKNUGWfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OJenQxIT; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OJenQxIT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784448996; x=1815984996;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=EW2UbSojXBwT+EJICSOzoXYA6+oI9eOxj59COlLMqnw=;
  b=OJenQxITWSQFh6REHYlEvdWdsP0XopxKtkZ58421eHZ9kGvy9CXxjwTK
   SV/YbpMLpABaZFY6ELKNNE3exV6fSqazGozp+BYQ8TqSyVByBdV30Qd1p
   CvNv8/AD1sZyTDt2oAN6VK87RfqgNFZYNk+IHEBrMpxcvWwMN6ov61E/6
   Li/MSLariBN93AXZ7M0eUgtuynhisa73vO2wFl3dZfjzoQZ1t8D3tikaf
   qnDr9s0x46Gj8w0c78JFMarGk3Rqm/pEcztLXqFZEc3M+Ve2GFx1g5BCc
   bAMPJ3hOv/FVUCjpEEgxWIdNSA6FaLLqKAEcz/B/GF6BGoWKN/sgw8NOz
   w==;
X-CSE-ConnectionGUID: XCaSPlzOSX6Zrh33wwgZ0A==
X-CSE-MsgGUID: umWXn117QxisMxenSMrPRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11850"; a="85259727"
X-IronPort-AV: E=Sophos;i="6.25,172,1779174000"; 
   d="scan'208";a="85259727"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2026 01:16:32 -0700
X-CSE-ConnectionGUID: 0cqYLGA+SyC7yqTNKKWhUQ==
X-CSE-MsgGUID: ms2ICxx5S92Wi9jyEzJ7Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,172,1779174000"; 
   d="scan'208";a="287234017"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2026 01:16:31 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 19 Jul 2026 01:16:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sun, 19 Jul 2026 01:16:30 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.34) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 19 Jul 2026 01:16:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LE1PyERz1V6dGARqhjK4+e2B14WiZ9dlkHAp/jrn045dU59/KVnpUC+y3ANgfRcMmbRLNBc7FJ6SMPp1F6mS/25ZW8IFIrfWP11y+IpV+WO6Xp6XrkIbI8q7AZYZHbjIYyAQyqS0FJiHH4pbtLDMrD3YE2+S4Xcewjo7o3h4SHS7kEmP0kotyxQYSdrB5YsLryKyMVr/kqaSrRXk7SPAQna3knZG9YZ+UlGwXtqsIzUuVAvsfvZQUxsFdWWbmfwOkvaIjY/2IquShhHhmmy3l5OTbwX5IxZCri7VSo+uZPe+Xo5AVyV7Cq0yyhNxbzVqdOK4zZnmE9tK3lYjTp1a2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcyyABjktbPpzyFR9hTxH35T3YkofB/Ygi5HG+8w7C0=;
 b=QEZycghcFUPw8Sxnam+gzOdCxDxPUSqvfqS5Fd2gi+F2H0q3dwBv1DvxH8SB+N45KuuzrdzhF82R9f+dPY8b8Hb3zMFECTeiT6l8Jbyk8btGQ+3+Eie0GmWOgYqsLOiXFBohnrk2pRbPYYWtA9i/bkW0sjAdDsjQVNx35ckyJKtJjb1xMM8enlqEgMPQ0NwUp5/FG3BoxU0rwDaxnD2+2++By0aDQ5fDhPfVxGTXn4ufcEj/SmEz0NALys+dWWuuEPhLVbEGshWp+ZqG+QSSGeafBoa7HgBCjs/K7u3gJgUSLXBlOWa0bYb3Dez9m/IxNpyZA/YkvdfbzGrpqI4MfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by LVXPR11MB9706.namprd11.prod.outlook.com (2603:10b6:408:388::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Sun, 19 Jul
 2026 08:16:21 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0223.013; Sun, 19 Jul 2026
 08:16:20 +0000
Date: Sun, 19 Jul 2026 16:16:14 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: Re: [linus:master] [xfs]  9b64ca202f:
 fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec 24.1% regression
Message-ID: <alyHzqUcyw4+EIPp@xsang-OptiPlex-9020>
References: <202607161601.867c143e-lkp@intel.com>
 <20260717064807.GA23992@lst.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260717064807.GA23992@lst.de>
X-ClientProxiedBy: TPYP295CA0060.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::19) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|LVXPR11MB9706:EE_
X-MS-Office365-Filtering-Correlation-Id: 539fb8f6-00bb-43ea-f0fa-08dee56e03c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 1kiUlcwr+vQrmDzIu0VFLHOQz2VYHjpw6UGpZYYJxFc0t8ymxDIzj5o5SVETVClr8VkvtQi/no1JZhuMHFtoyznLmMHfq3B+zJWTfpB+sLSuC13WYCfSBBquvQ0qP9z5UOCB8XTIluIKi2iiIhedB2MuYPEOKjA6g3qZ4CaI3gcnppl/Fy+wTRMxvvhuNtlioMpw7rDpUBKUV6+LZkIDMxInZi+HmB+kOcuEzujkWhKPnX+u9OCyOITxASN7Y+40y2ixZbh0tZEqJbJW4gIFBEeYDIKg6kRJXQefRKHistAuk7N5kq9C7GsWBZR7e+cfSzvPbriElpwo2yzPmFsIwPj5rXTh7Pg4VVwvtdsuKStLkEkZ8jQCRhxbdJy8A86PldltkVsohGGONbMIeDErJer4B4qsPwWkiEhgx5M7shCBJj76FAkDt9oxRXzMNgA+FaVoZt5J4N3CXhYSot+6WqgXP6n63xxtLacOqzWVt/SLIFAH39/oSvDhCSWFaR+5QfBg/X8dA4om/C+MinYTGLbN/lL8qWBRPNzLZ+1g4KKqvr1O3ESPZ0gpdP2DmZc4qJgrD3vHdTFxAQcLrBtjhmsA2vzXMD/dtoR6uus3PgxyEDQKkIO+UC3LiTehn8UCNgCAo/a4aULBTJkUGViBBt+EZ31C47lJ9oOQ7nHpHZQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?UZku/o0QIN8dhPKO7jtSzmbmUI/JET2byw6JHWjODVeJpjqWi/Y+KyyReF?=
 =?iso-8859-1?Q?kYVuZuTZP9VnLpizLFZ7uwjpRvdm6ZCN1hugCzLg3aOSUsJu1MZ03HEOa5?=
 =?iso-8859-1?Q?ertXL/9KzLiLNyxouVOF6wlV4XyLpZskWnGRRyPyQ/F0Fy7q3ueNVyeJKY?=
 =?iso-8859-1?Q?FxZT6bK1Mcueq6X6sYjXM6YyE9vB+mKgg08uRD9HGkR3wi8bmq/24jhtAM?=
 =?iso-8859-1?Q?BqNALXrqCseEt9mNXRZkvwsCsl252qV1O8d06UqxEzJADZrDTnFE3Ju+KV?=
 =?iso-8859-1?Q?PWXiFtp3RXYDgbPWnUC8TDJ1nxflF3pdTORu54UflLYyziW01v/W5zpVQT?=
 =?iso-8859-1?Q?VdEYv+6PVpnvzwhRs9r2hVUPcdogiPBcWv3jYDgugCh2we7CwPabUjdhmr?=
 =?iso-8859-1?Q?uh2f/yq6IVYOg2LPEMmsS04e9S2kxb2PJvvZpTC4zebKPcv7p2viV1d7JF?=
 =?iso-8859-1?Q?pQecQZ1KJE4enDiDG8xQo2ALUXXCaeejqVSvE1TBfH6+kNs5U9gqG1aWv0?=
 =?iso-8859-1?Q?eGNEhr9XQaDmPJzGByijLD44pSdg+U4tqAML/uvQc57DUenKaFRwluiqnY?=
 =?iso-8859-1?Q?yW4fOhazB68Z/WFMdLNl4EtqhMtbgWhFpIWXl2Kg53moKxbSKXKh/cUizL?=
 =?iso-8859-1?Q?pr0ugbBeD03zTzrSJBvKYXDFGNawwHd63onvjwxGjnhezzqoTHEHF1+a8j?=
 =?iso-8859-1?Q?hHRdvvTnLVQwMst+a3l16ArHM7c9NDfVOPaLmJFvsbVYULyTowmAERrQLG?=
 =?iso-8859-1?Q?F/xqoviaxP888UQSp7N7A+2/e1qBACpSL7bwpgIvtitPZzgXrOgveo6svb?=
 =?iso-8859-1?Q?Gd3y8imWGlIK3tKX6/uZvaW+Hq4tzTlFLjKecFBCO2aOQRd0LghY0rUnCd?=
 =?iso-8859-1?Q?Qf7ROc+f1ez8IszF8TG8x7dg879ZBpO/6sXdC1TxsQ6zBJC2rCkaGdnscz?=
 =?iso-8859-1?Q?hcQ3pOhNV2Mbgg/zXdrPAxBzFEkpkkiiMY2/8CbZac09MbJle5dc9d2RjA?=
 =?iso-8859-1?Q?8A0fTxeV1s1knAgV0qMOQfklVw7cijzKYtFTXCW6LgJOUZHCRMv5+Hhkx1?=
 =?iso-8859-1?Q?ImCbTE2DF0WkgEYChj/C0wZNGDo7Al+C+gnTfkOmUaw0qLw4DSMySvZjB9?=
 =?iso-8859-1?Q?BusYFxNtYeIWwG4Uph6ZTA5X3tZT5EVONa5ZD0kG0LajuTa3Gq52YLu5o2?=
 =?iso-8859-1?Q?j3PXf8XWurXf37vj+m9pNNQClCwCZN2Sri3y1W/tEi77FrvFMfdgH68d0m?=
 =?iso-8859-1?Q?k2HWy6Xxd3vmiK4Zc6ibz9NnGXl98CUUWRwtrBx6mfkxk9F6PDe025q5EX?=
 =?iso-8859-1?Q?9/pFIaUl2GLpzy5ASUDmxTxh+HZL2z+WbDeq1FT7w8Up7R1GiEzhUlkuP/?=
 =?iso-8859-1?Q?rRI1PDFiOILfb3xTZBUPcsGeJ7p4Q6uLLESkt8+3xT6E/5IJwMifIIPTKc?=
 =?iso-8859-1?Q?FRmQonShpgoUP1q5n+q90tAmmuP8TQsF68N6NhVRj9qSRclkAy6AVlknO6?=
 =?iso-8859-1?Q?NAxENiT5r99jUYzl6zNj4DZX4+HoPsIqOgAGhf9x1pje69i69V+u+bEXk7?=
 =?iso-8859-1?Q?Hgt0LLAYsKWTjtn5sgt6ZP46/rdTDceQdudv8mEDKw88jY7Q0/FDte9bHa?=
 =?iso-8859-1?Q?Tm4dwT+tx8PJQ5dACpE4TLy0tcbQETJX35d9kb16hfa3G/bVZ1ySvxtRVL?=
 =?iso-8859-1?Q?1KZGUg+nwphxDnQdMAb9ZcSajFC7vmbgJHaaC9QlkW5nWGWk2XpD3Z3w3S?=
 =?iso-8859-1?Q?A66yGLzanZg4dTxau1lLxzOjiYdPf+O4A2KmsTE1A58OBIq+np1SRlVkqM?=
 =?iso-8859-1?Q?twmZPsMPBg=3D=3D?=
X-Exchange-RoutingPolicyChecked: PPNhKMvFeYjHwlpvDEfM6A+Dq0abWoHG84DucJkk2O5KW7ncH3xxAiDYCmRqBEoG+JZU9Fsil1ASkwRnkfJt+IfLYX6x5YExIVQo1qv7uLwsQD/yw69a+4WcvWQCLRjsLEI0phdESdow1Nu28BBtS2ZW5cpFNg3xpTD2OHiA6H+piG7B8KzqWp27iV9+/zp0WeIK7fhSC3b/XKLFMaUnQiR7XgBqvXghb8ncWL+k+l1l5VO6F7fdGPRev4A0cZfaMI7PCwqt/oLuAm3Uv8OgR7Gy6wM4yzEjPzdAGWCVTG4ksPyUze97rEXFD42msqvQtXH+t8xlUICTxVkh7b9t7w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 539fb8f6-00bb-43ea-f0fa-08dee56e03c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2026 08:16:20.6934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4j2RPx4ZRvwoXKL0/QtYJWqPYyOwcfjcq5aJAc+xH1QtQWxli2nlsKnM8R11iola5R2/hF40p3P1WqrwK1rugA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR11MB9706
X-OriginatorOrg: intel.com

hi, Christoph Hellwig,

On Fri, Jul 17, 2026 at 08:48:07AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 16, 2026 at 09:13:19PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a 24.1% regression of fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec on:
> > 
> 
> This looks really odd.  While the patch adds a bit more computation,
> that is very cheap shifting and masking.  

in order to avoid the false positive, we rebuilt the kernel and rerun tests
on both 9b64ca202f and its parent. though the data has some differences with
last time, the regression trend is still similar - 21.8% regression this time.


> So the only theory I have here
> is that this somehow affects the inode data layout.  Can you re-run this
> with the patch below applied on top of commit
> 9b64ca202f364a6bf8e19bdd20953bc2d776c67f ?

yeah, but applying your patch upon 9b64ca202f, we saw the regression recovered.

from average data, it now becomes even little better than the parent of
9b64ca202f, i.e. caffb4252c, but since the data is not very stable - 4% stddev
for caffb4252c and 6% stddev for bd79e961ea, we cannot call +3.1% a valid
improvement according to our bot's rules.


=========================================================================================
compiler/cpufreq_governor/directio/disk/fstype/kconfig/media/rootfs/tbox_group/test/testcase/thread_nr:
  gcc-14/performance/bufferedio/1SSD/xfs/x86_64-rhel-9.4/ssd/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/DRBH/fxmark/4

commit: 
  caffb4252c ("xfs: massage xfs_imap_to_bp into xfs_read_icluster")
  9b64ca202f ("xfs: store an agbno in struct xfs_imap")
  bd79e961ea  <--- your patch applied upon 9b64ca202f

caffb4252cf15c5c 9b64ca202f364a6bf8e19bdd209 bd79e961eab5806b5c1321fba4d
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
 3.421e+08 ±  4%     -21.8%  2.674e+08 ±  3%      +3.1%  3.527e+08 ±  6%  fxmark.ssd_xfs_DRBH_4_bufferedio.works
   6842338 ±  4%     -21.8%    5348962 ±  3%      +3.1%    7054630 ±  6%  fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec
     21677            +2.3%      22181            +2.3%      22177        proc-vmstat.nr_mapped
      2.54 ±  6%     -15.1%       2.15 ±  7%      +2.5%       2.60 ±  7%  time.user_time
     87.25 ± 61%     +74.6%     152.38 ± 10%     +29.9%     113.38 ± 17%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.preempt_schedule_thunk.filemap_get_read_batch.filemap_get_pages.filemap_read
      2.18 ± 48%     +45.8%       3.18 ± 11%     +46.7%       3.20 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      6.89 ±123%      -2.7        4.16 ±122%      -2.1        4.82 ±131%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      6.89 ±123%      -2.7        4.16 ±122%      -2.1        4.82 ±131%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      6.89 ±123%      -2.7        4.16 ±122%      -2.1        4.82 ±131%  perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
      6.46 ±119%      -2.3        4.16 ±122%      -1.6        4.82 ±131%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      6.46 ±119%      -2.3        4.16 ±122%      -1.6        4.82 ±131%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      3.86 ± 78%      -2.2        1.61 ±182%      -2.4        1.44 ±179%  perf-profile.calltrace.cycles-pp.tear_down_vmas.exit_mmap.__mmput.exit_mm.do_exit
      5.44 ±102%      -1.5        3.94 ± 80%      -3.4        2.03 ±130%  perf-profile.calltrace.cycles-pp.free_pgtables.exit_mmap.__mmput.exit_mm.do_exit
      4.84 ± 94%      -3.0        1.82 ±175%      -2.1        2.72 ±103%  perf-profile.children.cycles-pp.mutex_unlock
      6.89 ±123%      -2.7        4.16 ±122%      -2.1        4.82 ±131%  perf-profile.children.cycles-pp.start_secondary
      3.86 ± 78%      -2.2        1.61 ±182%      -2.4        1.44 ±179%  perf-profile.children.cycles-pp.tear_down_vmas
      5.44 ±102%      -1.5        3.94 ± 80%      -3.4        2.03 ±130%  perf-profile.children.cycles-pp.free_pgtables
      4.87 ± 82%     +11.6       16.52 ±191%      -1.3        3.57 ±173%  perf-profile.children.cycles-pp.__free_one_page
      4.84 ± 94%      -3.0        1.82 ±175%      -2.1        2.72 ±103%  perf-profile.self.cycles-pp.mutex_unlock
      4.87 ± 82%     +10.8       15.63 ±205%      -1.3        3.57 ±173%  perf-profile.self.cycles-pp.__free_one_page


also list detail data this time FYI, we run tests upon each commit 8 times.

caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json:  "fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec": [
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    6178184.745545,
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    7016379.89853,
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    7178664.672853,
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    6975768.767642,
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    6671251.242517,
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    7013871.524931,
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    6760219.644392,
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-    6944366.470556
caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c/matrix.json-  ],

9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json:  "fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec": [
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5435146.379538,
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5468530.366732,
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5618409.657153,
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5184486.744613,
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5118827.985859,
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5623235.76661,
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5250286.871274,
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-    5092777.109583
9b64ca202f364a6bf8e19bdd20953bc2d776c67f/matrix.json-  ],

bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json:  "fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec": [
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    7501136.809977,
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    7459447.66,
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    6360107.595015,
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    6922348.764845,
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    7658169.213152,
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    6741170.118107,
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    7321403.278841,
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-    6473261.205802
bd79e961eab5806b5c1321fba4d0dcd6f2168711/matrix.json-  ],



> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 57192adc7744..319e83d4a087 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -15,6 +15,7 @@ struct xfs_dinode;
>   */
>  struct xfs_imap {
>  	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
> +	uint32_t	__im_pad;
>  	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
>  };
>  
