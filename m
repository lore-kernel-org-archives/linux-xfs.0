Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0FB47F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 16:15:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E022B304064
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 14:15:01 -0800 (PST)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id 8UbXD8Q00Xd9FanV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 14:14:38 -0800 (PST)
Message-ID: <52AB86B1.2070904@tlinx.org>
Date: Fri, 13 Dec 2013 14:14:09 -0800
From: "L.A. Walsh" <samba@tlinx.org>
MIME-Version: 1.0
Subject: Re: Security issue - storing NTACL's in non-NT-security-namespace
References: <52A96211.3050602@tlinx.org> <20131212181315.GB20500@samba2>
	<52AAC7CC.8000802@tlinx.org> <20131213105314.GA2117@infradead.org>
	<52AB7CDC.5040801@tlinx.org> <20131213220848.GG1005@samba2>
In-Reply-To: <20131213220848.GG1005@samba2>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeremy Allison <jra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Samba Technical <samba-technical@lists.samba.org>, xfs-oss <xfs@oss.sgi.com>

On 12/13/2013 2:08 PM, Jeremy Allison wrote:
> On Fri, Dec 13, 2013 at 01:32:12PM -0800, L.A. Walsh wrote:
>   
>> Now NOTE: if I don't use "explicit action" (-a) in my copy:
>>
>> Ishtar:law/Documents> /usr/bin/cp testfile.txt testcopy.txt
>> Ishtar:law/Documents> attr -l testcopy.txt
>> Attribute "SGI_ACL_FILE" has a 76 byte value for testcopy.txt
>>
>> ONLY the root-namespace ACL is save  -- the user and security
>> attributes are striped.
>>     
>
> What is the namespace for SGI_ACL_FILE ?
>   
root


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
