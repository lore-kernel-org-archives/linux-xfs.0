Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E383A7FA1
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:28:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5DD29AC003
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 03:28:29 -0700 (PDT)
Received: from mail-ie0-f174.google.com (mail-ie0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	LIjdkvkwsQJKFj0c (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 03:28:26 -0700 (PDT)
Received: by mail-ie0-f174.google.com with SMTP id rp18so2188740iec.5
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 03:28:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140714082607.GA19882@infradead.org>
References: <1404898212.7231.12.camel@jtulak>
	<20140709132836.GA65226@bfoster.bfoster>
	<20140710134851.GA26652@infradead.org>
	<1405009872.31068.22.camel@jtulak> <53BEC1E7.1070904@sandeen.net>
	<1405075678.28203.56.camel@jtulak> <1405325087.3196.6.camel@jtulak>
	<20140714082607.GA19882@infradead.org>
Date: Tue, 15 Jul 2014 12:28:26 +0200
Message-ID: <CAO78W=0Y-ja8U6ntkKHdOaXBhR5P4Ec8i+0ic3vTqZ5AugwP9A@mail.gmail.com>
Subject: Re: symlink loop for /lib64/libhandle.so
From: =?UTF-8?B?SmFuIMWkdWzDoWs=?= <jan@tulak.me>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, XFS mail list <xfs@oss.sgi.com>

2014-07-14 10:26 GMT+02:00 Christoph Hellwig <hch@infradead.org>:
>
> Can you just send the properly formatted and signed off patch to the
> list?  That's the usual process for XFS changes and makes everyones life
> simpler.
>

I hope this is all right.
And sorry Chris, I mistakenly replied just to you instead of into the
mailing list.


Reported-by: Jan Tulak <jan at tulak.me>
Signed-off-by: Jan Tulak <jan at tulak.me>
---
include/buildmacros | 6 +++++-
1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/buildmacros b/include/buildmacros
index 7a01880..657b82a 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -76,7 +76,11 @@ INSTALL_LTLIB_DEV = \
        ../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
        ../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
        ../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
-       if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)" ; then \
+       if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)"\
+       -a "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" != "x$(PKG_LIB_DIR)"\
+       -a "x$(shell readlink -f $(PKG_LIB_DIR))" != "x$(PKG_ROOT_LIB_DIR)"\
+       -a "x$(shell readlink -f $(PKG_LIB_DIR))" != "x$(shell
readlink -f $(PKG_ROOT_LIB_DIR))";\
+       then \
        ../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a
$(PKG_ROOT_LIB_DIR)/$(LIBNAME)
.a; \
        ../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la
$(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
        ../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so
$(PKG_LIB_DIR)/$(LIBNAME).so; \

2014-07-14 10:26 GMT+02:00 Christoph Hellwig <hch@infradead.org>:
> On Mon, Jul 14, 2014 at 10:04:47AM +0200, Jan ??ul??k wrote:
>> And I have created a bug report and added the proposed change as a
>> patch: http://oss.sgi.com/bugzilla/show_bug.cgi?id=1059
>
> Can you just send the properly formatted and signed off patch to the
> list?  That's the usual process for XFS changes and makes everyones life
> simpler.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
