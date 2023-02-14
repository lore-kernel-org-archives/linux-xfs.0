Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC850C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Feb 2023 18:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjBNSyK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 13:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjBNSyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 13:54:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E46828D15;
        Tue, 14 Feb 2023 10:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA99617F0;
        Tue, 14 Feb 2023 18:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199DDC433D2;
        Tue, 14 Feb 2023 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676400843;
        bh=K2DDIHEiIyne4n1DgOFX3CVGxS4L/67qUnBeSuoWC9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=flAJOO+G/IMnpPhenuhH5rBYqGg6AHrK/TPe7yFdvsFXu04RTPQZbJ0fNCJqIogF5
         kPNKG2S4EpQRgZmmxk4jTWZCcVOnemf8aVpNzFsN2dNm3Q5G/UVHRdKLG8CLzZDq0q
         5bzK1veEJ1+RaydmZ95VoPjvUcUw+qMSLKSE8D8ux2JFAcOdahGVui/WKyLfRVgx1J
         oodkT8DI8nW/FEI5PKBHZlxTVOTJMFmTZyvwgpqYDKMRS0pmyXhAO2GQx1xpdgDvA2
         n6KSjyRDk3pQJ6VIGhZWb8i2ofSLcpTfQWCnAujmg4MP41407xBz3Fjo90dg4Xx3Dn
         y2oOtkKLsqi7g==
Date:   Tue, 14 Feb 2023 10:54:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, leah.rumancik@gmail.com
Subject: Re: [PATCH 2/8] report: derive an xml schema for the xunit report
Message-ID: <Y+vYymqHVaPXUsra@magnolia>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149447509.332657.12495196329565215003.stgit@magnolia>
 <fc3f7649-162d-c149-74eb-ac38699bcb85@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3f7649-162d-c149-74eb-ac38699bcb85@gmx.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 10:18:18AM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/12/20 08:01, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The "xunit" report format emits an XML document that more or less
> > follows the junit xml schema.  However, there are two major exceptions:
> > 
> > 1. fstests does not emit an @errors attribute on the testsuite element
> > because we don't have the concept of unanticipated errors such as
> > "unchecked throwables".
> > 
> > 2. The system-out/system-err elements sound like they belong under the
> > testcase element, though the schema itself imprecisely says "while the
> > test was executed".  The schema puts them under the top-level testsuite
> > element, but we put them under the testcase element.
> > 
> > Define an xml schema for the xunit report format, and update the xml
> > headers to link to the schema file.  This enables consumers of the
> > reports to check mechanically that the incoming document follows the
> > format.
> 
> One thing is, does the official XMLs use tabs as indents?

XML doesn't care one way or another:
https://www.w3.org/TR/xml/#sec-white-space

> We got some lines definitely too long for human to read.
> Any way to make them a little better?

Eh, I guess I could change them to two spaces, given the indentyness of
the schema.

> But overall, it really defines a good standard for us to follow.
> This is definitely a good start.

<nod>

> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> [...]
> > +						<xs:choice minOccurs="0" maxOccurs="2">
> 
> For this, I prefer maxOccurs to be at least 3.
> 
> We have 3 different possible outputs:
> 
> - $seqnum.out.bad
> - $seqnum.full
> - $seqnum.dmesg
> 
> [...]
> 
> > +								</xs:annotation>
> > +								<xs:simpleType>
> > +									<xs:restriction base="pre-string">
> > +										<xs:whiteSpace value="preserve"/>
> > +									</xs:restriction>
> > +								</xs:simpleType>
> > +							</xs:element>
> > +							<xs:element name="system-err" minOccurs="0" maxOccurs="1">
> > +								<xs:annotation>
> > +									<xs:documentation xml:lang="en">Data that was written to standard error while the test was executed</xs:documentation>
> 
> We don't use stderr, but $seqnum.full and $seqnum.dmesg.
> 
> Or can we just rename the "system-out" and "system-err" to something fstests
> specific? E.g.
> 
> - system-output
> - system-full
> - system-dmesg
> 
> Or the system-err/out thing is mostly to keep the compatibility?
> If so, I'd prefer some properties to make it explicit which output
> represents which fstests specific output.

I'll change those, since that's one of the major divergences from the
upstream junit xml schema.  junit says system-out should capture the
stdout of the whole testsuite, not an individual testcase.

> 
> > +								</xs:annotation>
> > +								<xs:simpleType>
> > +									<xs:restriction base="pre-string">
> > +										<xs:whiteSpace value="preserve"/>
> > +									</xs:restriction>
> > +								</xs:simpleType>
> > +							</xs:element>
> > +						</xs:choice>
> > +					</xs:sequence>
> > +					<xs:attribute name="name" type="xs:token" use="required">
> > +						<xs:annotation>
> > +							<xs:documentation xml:lang="en">Name of the test method</xs:documentation>
> 
> Can we update the description to something more fstests specific, better
> with an example?
> Like "test case number, e.g. generic/001".
> 
> This can apply to most description copied from the JUnit doc.

Ok.

> [...]
> > +		<xs:attribute name="timestamp" type="ISO8601_DATETIME_PATTERN" use="required">
> > +			<xs:annotation>
> > +				<xs:documentation xml:lang="en">when the test was executed. Timezone may not be specified.</xs:documentation>
> > +			</xs:annotation>
> 
> This means the start time, thus all our existing timestamp is not following
> the spec already.

I wrote my comments about this part in the thread about patch 1, so
let's leave the discussion there.

--D

> Thanks,
> Qu
