Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:41222 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbeAEWsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jan 2018 17:48:08 -0500
Subject: Re: [V4, 01/11] Documentation: Add license-rules.rst to describe how
 to properly identify file licenses
References: <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20180105130526.GA31648@piout.net>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <7769bd49-146b-ea8c-3b2c-b5987653a665@gmail.com>
Date: Fri, 5 Jan 2018 14:48:04 -0800
MIME-Version: 1.0
In-Reply-To: <20180105130526.GA31648@piout.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On 01/05/18 05:05, Alexandre Belloni wrote:
> Hi,
> 
> I'm definitively late to the party but...
> 
> On 17/11/2017 at 11:00:33 +0100, Thomas Gleixner wrote:
>> +2. Style:
>> +
>> +   The SPDX license identifier is added in form of a comment.  The comment
>> +   style depends on the file type::
>> +
>> +      C source:   // SPDX-License-Identifier: <SPDX License Expression>
>> +      C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
>> +      ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
>> +      scripts:    # SPDX-License-Identifier: <SPDX License Expression>
>> +      .rst:	  .. SPDX-License-Identifier: <SPDX License Expression>
>> +      .dts{i}:	  // SPDX-License-Identifier: <SPDX License Expression>
> 
> dtc doesn't handle // comments. This works in the kernel tree because

dtc does handle // comments.


$ cat test_comment.dts 
/dts-v1/;

// this is comment 1

/* this is comment 2 */

/ {
	#address-cells = < 1 >;
	#size-cells = < 1 >;

	// this is comment 3

	tree_1: soc@0 {
		reg = <0x0 0x0>;
	};

};


Using the dtc version in linux v4.14:

$ dtc -v
Version: DTC 1.4.4-g756ffc4f

$ dtc -O dts test_comment.dts
/dts-v1/;

/ {
  	#address-cells = <0x1>;
	#size-cells = <0x1>;

	tree_1: soc@0 {
		reg = <0x0 0x0>;
	};
};


Using the latest dtc version in the git_dtc repo:

$ dtc -v
Version: DTC 1.4.6-ge5438801

$ dtc -O dts test_comment.dts 
/dts-v1/;

/ {
	#address-cells = <0x1>;
	#size-cells = <0x1>;

	tree_1: soc@0 {
		reg = <0x0 0x0>;
	};
};

-Frank


> dts files are preprocessed by CPP. But this doesn't work when using dtc
> directly (most likely when compiling DT overlays). So, the choice is
> between making dtc handle // comments or changing the documentation.
> 
> I don't have an opinion and Rob doesn't seem to care but I think we need
> to do something now instead of letting each maintainer have to handle
> this issue.
> 
>> +   If a specific tool cannot handle the standard comment style, then the
>> +   appropriate comment mechanism which the tool accepts shall be used. This
>> +   is the reason for having the "/\* \*/" style comment in C header
>> +   files. There was build breakage observed with generated .lds files where
>> +   'ld' failed to parse the C++ comment. This has been fixed by now, but
>> +   there are still older assembler tools which cannot handle C++ style
>> +   comments.
>> +

