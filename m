Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ACE687F76
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 10:49:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CF4B304043
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 08:49:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 0kVM4rkkbb3C1vQA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 08:48:59 -0700 (PDT)
Date: Tue, 15 Jul 2014 08:48:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: symlink loop for /lib64/libhandle.so
Message-ID: <20140715154857.GA14716@infradead.org>
References: <1404898212.7231.12.camel@jtulak>
	<20140709132836.GA65226@bfoster.bfoster>
	<20140710134851.GA26652@infradead.org>
	<1405009872.31068.22.camel@jtulak> <53BEC1E7.1070904@sandeen.net>
	<1405075678.28203.56.camel@jtulak> <1405325087.3196.6.camel@jtulak>
	<20140714082607.GA19882@infradead.org>
	<CAO78W=0Y-ja8U6ntkKHdOaXBhR5P4Ec8i+0ic3vTqZ5AugwP9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <CAO78W=0Y-ja8U6ntkKHdOaXBhR5P4Ec8i+0ic3vTqZ5AugwP9A@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan ??ul??k <jan@tulak.me>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, XFS mail list <xfs@oss.sgi.com>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jan,

there were still some small isues with the patch format, I've attached
a version of your patch that has the expected format.

Note that I also changed it to only check the canonical names instead of
testing the passed in one and the one readlink was called on.  This
should be enough I think, but please test that it still works for you.

Thanks for tracking this down!

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libhandle.diff"

From: Jan Tulak <jan@tulak.me>
Subject: [PATCH] libhandle: fix instalation for symlinked /usr

Canonicalize the pathnames for PKG_LIB_DIR and PKG_ROOT_LIB_DIR before
checking if they are the same.  This is required for Fedora which doesn't
have a separate /usr/lib directory anymore.

Reported-by: Jan Tulak <jan@tulak.me>
Signed-off-by: Jan Tulak <jan@tulak.me>

diff --git a/include/buildmacros b/include/buildmacros
index 7a01880..4e4e8fa 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -76,10 +76,11 @@ INSTALL_LTLIB_DEV = \
 	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
 	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
 	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
-	if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)" ; then \
-	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
-	../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
-	../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
+	if [ "x$(shell readlink -f $(PKG_LIB_DIR))" != \
+	     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))"; ]; then \
+		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
+		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
+		../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
 	fi
 else
 INSTALL_LTLIB_DEV = $(INSTALL_LTLIB_STATIC)

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--4Ckj6UjgE2iN1+kY--
