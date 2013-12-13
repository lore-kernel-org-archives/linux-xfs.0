Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14CF47F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 16:09:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 040938F8040
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 14:09:38 -0800 (PST)
Received: from mail.samba.org (fn.samba.org [216.83.154.106]) by cuda.sgi.com
	with ESMTP id DCP6BbvWum31nKwG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 14:09:11 -0800 (PST)
Date: Fri, 13 Dec 2013 14:08:48 -0800
From: Jeremy Allison <jra@samba.org>
Subject: Re: Security issue - storing NTACL's in non-NT-security-namespace
Message-ID: <20131213220848.GG1005@samba2>
References: <52A96211.3050602@tlinx.org> <20131212181315.GB20500@samba2>
	<52AAC7CC.8000802@tlinx.org> <20131213105314.GA2117@infradead.org>
	<52AB7CDC.5040801@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52AB7CDC.5040801@tlinx.org>
Reply-To: Jeremy Allison <jra@samba.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "L.A. Walsh" <samba@tlinx.org>
Cc: Christoph Hellwig <hch@infradead.org>, Samba Technical <samba-technical@lists.samba.org>, Jeremy Allison <jra@samba.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 13, 2013 at 01:32:12PM -0800, L.A. Walsh wrote:
> Now NOTE: if I don't use "explicit action" (-a) in my copy:
> 
> Ishtar:law/Documents> /usr/bin/cp testfile.txt testcopy.txt
> Ishtar:law/Documents> attr -l testcopy.txt
> Attribute "SGI_ACL_FILE" has a 76 byte value for testcopy.txt
> 
> ONLY the root-namespace ACL is save  -- the user and security
> attributes are striped.

What is the namespace for SGI_ACL_FILE ?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
