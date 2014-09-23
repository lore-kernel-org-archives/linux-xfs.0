Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C44E29DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 13:34:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90297AC007
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 11:34:25 -0700 (PDT)
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id vF9YNc75bLkbQ4Ad for
	<xfs@oss.sgi.com>; Tue, 23 Sep 2014 11:34:20 -0700 (PDT)
Subject: Re: [PATCH 07a/13] xfsprogs: add trie generator for UTF-8.
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20140919160612.GF4482@sgi.com>
References: <20140918195650.GI19952@sgi.com> <20140918203114.GN4482@sgi.com>
	<20140919160612.GF4482@sgi.com>
Date: Tue, 23 Sep 2014 19:34:19 +0100
Message-Id: <1411497259.4842.163.camel@localhost.localdomain>
Mime-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com


On Fri, 2014-09-19 at 11:06 -0500, Ben Myers wrote:
> +#define AGE_NAME       "DerivedAge.txt"
> +#define CCC_NAME       "DerivedCombiningClass.txt"
> +#define PROP_NAME      "DerivedCoreProperties.txt"
> +#define DATA_NAME      "UnicodeData.txt"
> +#define FOLD_NAME      "CaseFolding.txt"
> +#define NORM_NAME      "NormalizationCorrections.txt"
> +#define TEST_NAME      "NormalizationTest.txt"

Is there a reason why you're using multiple text-based data files (and
hand-parsing them) when there's an xml formatted flat file available ?

http://www.unicode.org/Public/UCD/latest/ucdxml/


And a 2nd question - why does the trie need to encode "the the unicode
version in which the codepoint was assigned an interpretation" ?


-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
