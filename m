Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 22:03:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5E52uWt031046
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 22:02:58 -0700
Date: Thu, 14 Jun 2007 15:06:01 +1000
Subject: Review: dmapi-devel RPM should required xfsprogs-devel RPM
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
Message-ID: <op.ttwa4bv73jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>


As per the subject (and also mentioned in the description):

--- a/dmapi/build/rpm/dmapi.spec.in     2007-06-14 15:02:13.000000000 +1000
+++ b/dmapi/build/rpm/dmapi.spec.in     2007-06-14 14:47:31.290063558 +1000
@@ -23,7 +23,7 @@
  %package devel
  Summary: Data Management API static libraries and headers.
  Group: Development/Libraries
-Requires: @pkg_name@ >= 2.0.4
+Requires: @pkg_name@ >= 2.0.4 xfsprogs-devel

  %description devel
  dmapi-devel contains the libraries and header files needed to
