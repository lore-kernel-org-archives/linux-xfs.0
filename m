Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5A2C33CAE
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 07:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 786322073D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 07:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAMHq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 02:46:27 -0500
Received: from mail01.vodafone.es ([217.130.24.71]:40832 "EHLO
        mail01.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgAMHq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 02:46:27 -0500
IronPort-SDR: nbNrBILHkTPdG78doQAXPAxkdZSHBmAYlQcQO1LfpzkDyJfpYR47S+3DWUzHlMQNRD/4h87t+J
 CW3zPWWY2nog==
IronPort-PHdr: =?us-ascii?q?9a23=3AttObqRHisHLYEegz6Xqx6p1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ7zrsywAkXT6L1XgUPTWs2DsrQY0rGQ6f6xEjVZut6oizMrSNR0TR?=
 =?us-ascii?q?gLiMEbzUQLIfWuLgnFFsPsdDEwB89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ?=
 =?us-ascii?q?/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL9vIhi6txvdu8gSjIdtN6o91x?=
 =?us-ascii?q?XEqWZUdupLwm9lOUidlAvm6Meq+55j/SVQu/Y/+MNFTK73Yac2Q6FGATo/K2?=
 =?us-ascii?q?w669HluhfFTQuU+3sTSX4WnQZSAwjE9x71QJH8uTbnu+Vn2SmaOcr2Ta0oWT?=
 =?us-ascii?q?mn8qxmRgPkhDsBOjUk9m3bjdF+g75BrxKkpx1z2pDZYIaPNPpmeaPdZ8kVRX?=
 =?us-ascii?q?ZfUcpISSNBBJqwYpcTD+odJ+lXs4n9qEULrRSgAwmsGPrjxSFOhnPv2qM61O?=
 =?us-ascii?q?IhHh/G3QA5Ad0OtmnfoNH7OasOTey5ya/FxijBYfxLwzfw8IbGfBA7of+SXr?=
 =?us-ascii?q?x+bMXexlUgGQ7eklWdq5DqMy+J2ugRrWSW6fdrW+K1i24grgF8uiKhydkwio?=
 =?us-ascii?q?bXnIIe11DL9SJ/wIY6ONa1T1Z7bsC4EJROrSGbOYx2QsUtQ2xzuCY60aYJto?=
 =?us-ascii?q?KhcCcWz5QnwgTTa/yEc4WR5B/oSeWfIS9giX57Zb6yhQy+/VWux+HgTMW4zl?=
 =?us-ascii?q?lHojBLn9TMsH0Gygbd5dKdSvRn+0eswTOP1wfO5e5aOU00jq/bK4I5wr43i5?=
 =?us-ascii?q?oTrVzPHi/ol0Xyi6+bbkAk9fKp6+TjeLXpuJucO5N7hw3kLKQundGwDv42Mg?=
 =?us-ascii?q?gJWWiU5/6w26P4/UHhQbVKiOM5krXBvZzEOMgWpLS1DxJb34o/8RqzETir3M?=
 =?us-ascii?q?4WkHQHNF5FfQiIj4ntO1HAOvD4CvK/jky0kDh12/DJIKfhA5vKLnjFn7fsZr?=
 =?us-ascii?q?Z961VHxwUv19xQ+5VUCrQbLPLzWU/9rMbYAQMhMwyo3+bnD81w1ocfWWKJH6?=
 =?us-ascii?q?+YP7resFCG5uI0OOSMeoAVtyjnK/Q/5P7hk2U5mVkDcqmtx5cXb2q4Hvs1a3?=
 =?us-ascii?q?meNH7thMoRVHcEpSIgQ+Hwzl6PSzheYzC1Ra1v3DwjDJOaCtL7S5ygmvS+2y?=
 =?us-ascii?q?G0VslOa3xLEE+LF3jodIWfUfwkZyebI8snmTsBA+uPUYgkgCmjqALgg4VgKO?=
 =?us-ascii?q?WcrjUVqZ/5y99z6MXTjhs5szdzCoKd0DfeHClPgmoUSmpvj+hEqktnxwLYif?=
 =?us-ascii?q?B1?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EGEgAxHxxeeiMYgtkUBjMYGgEBAQE?=
 =?us-ascii?q?BAQEBAQMBAQEBEQEBAQICAQEBAYF7AgEBFwEBgS6BTVIgEpNQgU0fg0OLY4E?=
 =?us-ascii?q?Agx4VhggTDIFbDQEBAQEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQ?=
 =?us-ascii?q?BAQIQAQEJDQsEK4VKgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVOFTwE?=
 =?us-ascii?q?BM4UllzoBhASJAA0NAoUdgkMECoEJgRojgTYBjBgagUE/gSMhgisIAYIBgn8?=
 =?us-ascii?q?BEgFsgkiCWQSNQhIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4R?=
 =?us-ascii?q?OgX2jN1eBDA16cTMagiYagSBPGA2WSECBFhACT4kugjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2EGEgAxHxxeeiMYgtkUBjMYGgEBAQEBAQEBAQMBAQEBE?=
 =?us-ascii?q?QEBAQICAQEBAYF7AgEBFwEBgS6BTVIgEpNQgU0fg0OLY4EAgx4VhggTDIFbD?=
 =?us-ascii?q?QEBAQEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQBAQIQAQEJDQsEK?=
 =?us-ascii?q?4VKgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVOFTwEBM4UllzoBhASJA?=
 =?us-ascii?q?A0NAoUdgkMECoEJgRojgTYBjBgagUE/gSMhgisIAYIBgn8BEgFsgkiCWQSNQ?=
 =?us-ascii?q?hIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4ROgX2jN1eBDA16c?=
 =?us-ascii?q?TMagiYagSBPGA2WSECBFhACT4kugjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,428,1571695200"; 
   d="scan'208";a="304667141"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 13 Jan 2020 08:46:24 +0100
Received: (qmail 25552 invoked from network); 12 Jan 2020 05:00:27 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <linux-xfs@vger.kernel.org>; 12 Jan 2020 05:00:27 -0000
Date:   Sun, 12 Jan 2020 06:00:20 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     linux-xfs@vger.kernel.org
Message-ID: <2724645.461147.1578805227777.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

