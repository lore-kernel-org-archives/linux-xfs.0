Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C7CC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 02:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLTCSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 21:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTCSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 21:18:45 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635632DC2;
        Mon, 19 Dec 2022 18:18:35 -0800 (PST)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MUosT-1pG51j1EDB-00Qmw3; Tue, 20
 Dec 2022 03:18:23 +0100
Message-ID: <fc3f7649-162d-c149-74eb-ac38699bcb85@gmx.com>
Date:   Tue, 20 Dec 2022 10:18:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149447509.332657.12495196329565215003.stgit@magnolia>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH 2/8] report: derive an xml schema for the xunit report
In-Reply-To: <167149447509.332657.12495196329565215003.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:gJRU64qGqYy5KT3bkGZ+P0k0xXX+nC3+m0uWD2yIo8B8usnL3OV
 z3Vlq493xweev7iCXRRVVrQr1AEcR8YD33ximIsI8HUOoHV1MzYvqdqSIGJtWijcHAyUO/s
 WV0GaRixj3oomfPdlEKvIq4pV5ytZC5ypNRfpPKoYK7fjLzK3gBoYtwDqGvzpK+WMteFC62
 VNtZvsveCvbxJdPgYnrgA==
UI-OutboundReport: notjunk:1;M01:P0:CFatJcTPun8=;eGbL/tXS17urvQs2zOMWM5rpwwz
 oXlrUvB5yRliG3HR/3uA+gCk1NCLP4XPsUOZsS1kkwxgop03wUUbU8r/y+AuprZkJw8z9Lxzn
 ydZsQwXGqKra2FlqE8ati1BkwAGMfjwc74KrszjNzuBIzk3QegYPQbKz6Z4NKx7lqj/EAC+9E
 t1Rbawav75+ppwV032L1H4kCQeVnbLEnqT4W8fPP4TXFpRKKYiUti1ZcHVDOyTmdTuN1F7eSD
 RbhVt6z5e+flaLZVBKVJWGKawi0GxeJaQv0STgb81OM+vgniy8P0svfCtIZWsckVd8M0M/BvO
 AA2KrAgztTP6wT/ql9aFI7sVN3fy/MoLrxprukjIWzAQVi/MBbjk/fG5PSn1n4khoGgfp2jFQ
 5OU9C8iaGnS3H4bB1VgLiT6d4y352MmYRi1F4z9d0SWctSQU4uRJWjXAzQAiYxfJwea9cQrfW
 ef65u7h2fHN3yS82xNnAYKk09wdHwg7Kt2UG77cWOqiKpWIkRJFlMCdu1iVCPnrModZYUODZ5
 Fx04Qrg+QvdS3QvZ+sk3aZllZJy6w92QHTlekEUGtRT6fVRckMMmmSsiLu51tR/861UBsxT8x
 wMDlOLfELT6YGD0mVWZ8XCo9tmGZVaTnF2OJFURcyb1WQpUZrF911XWPKJr0bGhB/3DrPSwoH
 BlDQ1LnXmmw5ItKiRwle69STkrUkeVciFZtCRYrc9qhjHFwls1fH0c32evl9a7TFrHpmq2Qc1
 L06jQKOZhGL+BEARP+ROqreiXAG3mk3saN11NB5vR8vjUBAY1R6z+dQe8EKjicy96lsjow9kV
 x3Qa65VD0G9S9TSfT/YFVIFncosuatrrsFjjrjEu9unmF8p9J8A6AOLylmxph/fyRhhaduBgX
 X5opeXvZ/YM8x9gyrOfNVCn10Z140B8FYAnOWDQ2ItFSI8yHYnizcksqNvfrW/c270DlTGkJO
 Abbn/qlzP/eD1GduVLn1QfwuOHo=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2022/12/20 08:01, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The "xunit" report format emits an XML document that more or less
> follows the junit xml schema.  However, there are two major exceptions:
> 
> 1. fstests does not emit an @errors attribute on the testsuite element
> because we don't have the concept of unanticipated errors such as
> "unchecked throwables".
> 
> 2. The system-out/system-err elements sound like they belong under the
> testcase element, though the schema itself imprecisely says "while the
> test was executed".  The schema puts them under the top-level testsuite
> element, but we put them under the testcase element.
> 
> Define an xml schema for the xunit report format, and update the xml
> headers to link to the schema file.  This enables consumers of the
> reports to check mechanically that the incoming document follows the
> format.

One thing is, does the official XMLs use tabs as indents?

We got some lines definitely too long for human to read.
Any way to make them a little better?

But overall, it really defines a good standard for us to follow.
This is definitely a good start.

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
[...]
> +						<xs:choice minOccurs="0" maxOccurs="2">

For this, I prefer maxOccurs to be at least 3.

We have 3 different possible outputs:

- $seqnum.out.bad
- $seqnum.full
- $seqnum.dmesg

[...]

> +								</xs:annotation>
> +								<xs:simpleType>
> +									<xs:restriction base="pre-string">
> +										<xs:whiteSpace value="preserve"/>
> +									</xs:restriction>
> +								</xs:simpleType>
> +							</xs:element>
> +							<xs:element name="system-err" minOccurs="0" maxOccurs="1">
> +								<xs:annotation>
> +									<xs:documentation xml:lang="en">Data that was written to standard error while the test was executed</xs:documentation>

We don't use stderr, but $seqnum.full and $seqnum.dmesg.

Or can we just rename the "system-out" and "system-err" to something 
fstests specific? E.g.

- system-output
- system-full
- system-dmesg

Or the system-err/out thing is mostly to keep the compatibility?
If so, I'd prefer some properties to make it explicit which output 
represents which fstests specific output.

> +								</xs:annotation>
> +								<xs:simpleType>
> +									<xs:restriction base="pre-string">
> +										<xs:whiteSpace value="preserve"/>
> +									</xs:restriction>
> +								</xs:simpleType>
> +							</xs:element>
> +						</xs:choice>
> +					</xs:sequence>
> +					<xs:attribute name="name" type="xs:token" use="required">
> +						<xs:annotation>
> +							<xs:documentation xml:lang="en">Name of the test method</xs:documentation>

Can we update the description to something more fstests specific, better 
with an example?
Like "test case number, e.g. generic/001".

This can apply to most description copied from the JUnit doc.

[...]
> +		<xs:attribute name="timestamp" type="ISO8601_DATETIME_PATTERN" use="required">
> +			<xs:annotation>
> +				<xs:documentation xml:lang="en">when the test was executed. Timezone may not be specified.</xs:documentation>
> +			</xs:annotation>

This means the start time, thus all our existing timestamp is not 
following the spec already.

Thanks,
Qu
