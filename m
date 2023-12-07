Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFD710CF
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 00:39:06 -0800 (PST)
Received: from dggpeml500017.china.huawei.com (unknown [172.30.72.56])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Sm6xn20qFz14Lrl;
	Thu,  7 Dec 2023 16:34:05 +0800 (CST)
Received: from [10.174.178.2] (10.174.178.2) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 7 Dec
 2023 16:39:04 +0800
Content-Type: multipart/mixed;
	boundary="------------1WfI1zBWZgb47W4eSd2TTvRP"
Message-ID: <619020bd-800a-431a-bb1d-937ad1cdc270@huawei.com>
Date: Thu, 7 Dec 2023 16:39:04 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>
CC: <louhongxiang@huawei.com>
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
Subject: [PATCH] xfs_grow: Remove xflag and iflag to reduce redundant
 temporary variables.
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected

--------------1WfI1zBWZgb47W4eSd2TTvRP
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

I found that iflag and xflag can be combined with lflag to reduce the 
number of redundant local variables, which is a refactoring to improve 
code readability.Signed-off-by: Wu YiFeng <wuyifeng10@huawei.com>

Please help me review, thanks.

---
  growfs/xfs_growfs.c | 22 +++++++++++-----------
  1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 683961f6..5fb1a9d2 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -8,6 +8,10 @@
  #include "libfrog/paths.h"
  #include "libfrog/fsgeom.h"

+#define LOG_GROW    (1<<0)    /* -l flag: grow log section */
+#define LOG_EXT2INT    (1<<1)    /* -i flag: convert log from external 
to internal format */
+#define LOG_INT2EXT    (1<<2)    /* -x flag: convert log from internal 
to external format */
+
  static void
  usage(void)
  {
@@ -45,7 +49,6 @@ main(int argc, char **argv)
      long            esize;    /* new rt extent size */
      int            ffd;    /* mount point file descriptor */
      struct xfs_fsop_geom    geo;    /* current fs geometry */
-    int            iflag;    /* -i flag */
      int            isint;    /* log is currently internal */
      int            lflag;    /* -l flag */
      long long        lsize;    /* new log size in fs blocks */
@@ -55,7 +58,6 @@ main(int argc, char **argv)
      struct xfs_fsop_geom    ngeo;    /* new fs geometry */
      int            rflag;    /* -r flag */
      long long        rsize;    /* new rt size in fs blocks */
-    int            xflag;    /* -x flag */
      char            *fname;    /* mount point name */
      char            *datadev; /* data device name */
      char            *logdev;  /*  log device name */
@@ -72,7 +74,7 @@ main(int argc, char **argv)

      maxpct = esize = 0;
      dsize = lsize = rsize = 0LL;
-    aflag = dflag = iflag = lflag = mflag = nflag = rflag = xflag = 0;
+    aflag = dflag = lflag = mflag = nflag = rflag = 0;

      while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
          switch (c) {
@@ -87,13 +89,13 @@ main(int argc, char **argv)
              rflag = 1;
              break;
          case 'i':
-            lflag = iflag = 1;
+            lflag |= LOG_EXT2INT;
              break;
          case 'L':
              lsize = strtoll(optarg, NULL, 10);
              fallthrough;
          case 'l':
-            lflag = 1;
+            lflag |= LOG_GROW;
              break;
          case 'm':
              mflag = 1;
@@ -115,7 +117,7 @@ main(int argc, char **argv)
              mtab_file = optarg;
              break;
          case 'x':
-            lflag = xflag = 1;
+            lflag |= LOG_INT2EXT;
              break;
          case 'V':
              printf(_("%s version %s\n"), progname, VERSION);
@@ -124,9 +126,7 @@ main(int argc, char **argv)
              usage();
          }
      }
-    if (argc - optind != 1)
-        usage();
-    if (iflag && xflag)
+    if (argc - optind != 1 || ((lflag & LOG_EXT2INT) && (lflag & 
LOG_INT2EXT)))
          usage();
      if (dflag + lflag + rflag + mflag == 0)
          aflag = 1;
@@ -323,9 +323,9 @@ _("[EXPERIMENTAL] try to shrink unused space %lld, 
old size is %lld\n"),

          if (!lsize)
              lsize = dlsize / (geo.blocksize / BBSIZE);
-        if (iflag)
+        if (lflag & LOG_EXT2INT)
              in.isint = 1;
-        else if (xflag)
+        else if (lflag & LOG_INT2EXT)
              in.isint = 0;
          else
              in.isint = xi.logBBsize == 0;
-- 
2.33.0


--------------1WfI1zBWZgb47W4eSd2TTvRP
Content-Type: text/plain; charset="UTF-8";
	name="0001-xfs_grow-Remove-redundant-xflag-and-iflag.patch"
Content-Disposition: attachment;
	filename="0001-xfs_grow-Remove-redundant-xflag-and-iflag.patch"
Content-Transfer-Encoding: base64

RnJvbSA3NGM5ZmUzMzM3YTMwMjM4NTk5OWI1N2NlYjgxOWIzNDM5Y2RiZDljIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBXdSBZaUZlbmcgPHd1eWlmZW5nMTBAaHVhd2VpLmNv
bT4KRGF0ZTogVGh1LCA3IERlYyAyMDIzIDE1OjQ3OjA4ICswODAwClN1YmplY3Q6IFtQQVRD
SF0geGZzX2dyb3c6IFJlbW92ZSB4ZmxhZyBhbmQgaWZsYWcgdG8gcmVkdWNlIHJlZHVuZGFu
dAogdGVtcG9yYXJ5IHZhcmlhYmxlcy4KCkJvdGggeGZsYWcgYW5kIGlmbGFnIGFyZSBsb2cg
ZmxhZ3MuIFdlIGNhbiB1c2UgdGhlIGJpdHMgb2YgbGZsYWcgdG8KaW5kaWNhdGUgYWxsIGxv
ZyBmbGFncywgd2hpY2ggaXMgYSBzbWFsbCBjb2RlIHJlY29uc3RydWN0aW9uLgoKU2lnbmVk
LW9mZi1ieTogV3UgWWlGZW5nIDx3dXlpZmVuZzEwQGh1YXdlaS5jb20+Ci0tLQogZ3Jvd2Zz
L3hmc19ncm93ZnMuYyB8IDIyICsrKysrKysrKysrLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFu
Z2VkLCAxMSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9n
cm93ZnMveGZzX2dyb3dmcy5jIGIvZ3Jvd2ZzL3hmc19ncm93ZnMuYwppbmRleCA2ODM5NjFm
Ni4uNWZiMWE5ZDIgMTAwNjQ0Ci0tLSBhL2dyb3dmcy94ZnNfZ3Jvd2ZzLmMKKysrIGIvZ3Jv
d2ZzL3hmc19ncm93ZnMuYwpAQCAtOCw2ICs4LDEwIEBACiAjaW5jbHVkZSAibGliZnJvZy9w
YXRocy5oIgogI2luY2x1ZGUgImxpYmZyb2cvZnNnZW9tLmgiCiAKKyNkZWZpbmUgTE9HX0dS
T1cJKDE8PDApCS8qIC1sIGZsYWc6IGdyb3cgbG9nIHNlY3Rpb24gKi8KKyNkZWZpbmUgTE9H
X0VYVDJJTlQJKDE8PDEpCS8qIC1pIGZsYWc6IGNvbnZlcnQgbG9nIGZyb20gZXh0ZXJuYWwg
dG8gaW50ZXJuYWwgZm9ybWF0ICovCisjZGVmaW5lIExPR19JTlQyRVhUCSgxPDwyKQkvKiAt
eCBmbGFnOiBjb252ZXJ0IGxvZyBmcm9tIGludGVybmFsIHRvIGV4dGVybmFsIGZvcm1hdCAq
LworCiBzdGF0aWMgdm9pZAogdXNhZ2Uodm9pZCkKIHsKQEAgLTQ1LDcgKzQ5LDYgQEAgbWFp
bihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJbG9uZwkJCWVzaXplOwkvKiBuZXcgcnQgZXh0
ZW50IHNpemUgKi8KIAlpbnQJCQlmZmQ7CS8qIG1vdW50IHBvaW50IGZpbGUgZGVzY3JpcHRv
ciAqLwogCXN0cnVjdCB4ZnNfZnNvcF9nZW9tCWdlbzsJLyogY3VycmVudCBmcyBnZW9tZXRy
eSAqLwotCWludAkJCWlmbGFnOwkvKiAtaSBmbGFnICovCiAJaW50CQkJaXNpbnQ7CS8qIGxv
ZyBpcyBjdXJyZW50bHkgaW50ZXJuYWwgKi8KIAlpbnQJCQlsZmxhZzsJLyogLWwgZmxhZyAq
LwogCWxvbmcgbG9uZwkJbHNpemU7CS8qIG5ldyBsb2cgc2l6ZSBpbiBmcyBibG9ja3MgKi8K
QEAgLTU1LDcgKzU4LDYgQEAgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJc3RydWN0
IHhmc19mc29wX2dlb20JbmdlbzsJLyogbmV3IGZzIGdlb21ldHJ5ICovCiAJaW50CQkJcmZs
YWc7CS8qIC1yIGZsYWcgKi8KIAlsb25nIGxvbmcJCXJzaXplOwkvKiBuZXcgcnQgc2l6ZSBp
biBmcyBibG9ja3MgKi8KLQlpbnQJCQl4ZmxhZzsJLyogLXggZmxhZyAqLwogCWNoYXIJCQkq
Zm5hbWU7CS8qIG1vdW50IHBvaW50IG5hbWUgKi8KIAljaGFyCQkJKmRhdGFkZXY7IC8qIGRh
dGEgZGV2aWNlIG5hbWUgKi8KIAljaGFyCQkJKmxvZ2RldjsgIC8qICBsb2cgZGV2aWNlIG5h
bWUgKi8KQEAgLTcyLDcgKzc0LDcgQEAgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAK
IAltYXhwY3QgPSBlc2l6ZSA9IDA7CiAJZHNpemUgPSBsc2l6ZSA9IHJzaXplID0gMExMOwot
CWFmbGFnID0gZGZsYWcgPSBpZmxhZyA9IGxmbGFnID0gbWZsYWcgPSBuZmxhZyA9IHJmbGFn
ID0geGZsYWcgPSAwOworCWFmbGFnID0gZGZsYWcgPSBsZmxhZyA9IG1mbGFnID0gbmZsYWcg
PSByZmxhZyA9IDA7CiAKIAl3aGlsZSAoKGMgPSBnZXRvcHQoYXJnYywgYXJndiwgImREOmU6
aWxMOm06bnA6clI6dDp4ViIpKSAhPSBFT0YpIHsKIAkJc3dpdGNoIChjKSB7CkBAIC04Nywx
MyArODksMTMgQEAgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJCQlyZmxhZyA9IDE7
CiAJCQlicmVhazsKIAkJY2FzZSAnaSc6Ci0JCQlsZmxhZyA9IGlmbGFnID0gMTsKKwkJCWxm
bGFnIHw9IExPR19FWFQySU5UOwogCQkJYnJlYWs7CiAJCWNhc2UgJ0wnOgogCQkJbHNpemUg
PSBzdHJ0b2xsKG9wdGFyZywgTlVMTCwgMTApOwogCQkJZmFsbHRocm91Z2g7CiAJCWNhc2Ug
J2wnOgotCQkJbGZsYWcgPSAxOworCQkJbGZsYWcgfD0gTE9HX0dST1c7CiAJCQlicmVhazsK
IAkJY2FzZSAnbSc6CiAJCQltZmxhZyA9IDE7CkBAIC0xMTUsNyArMTE3LDcgQEAgbWFpbihp
bnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJCQltdGFiX2ZpbGUgPSBvcHRhcmc7CiAJCQlicmVh
azsKIAkJY2FzZSAneCc6Ci0JCQlsZmxhZyA9IHhmbGFnID0gMTsKKwkJCWxmbGFnIHw9IExP
R19JTlQyRVhUOwogCQkJYnJlYWs7CiAJCWNhc2UgJ1YnOgogCQkJcHJpbnRmKF8oIiVzIHZl
cnNpb24gJXNcbiIpLCBwcm9nbmFtZSwgVkVSU0lPTik7CkBAIC0xMjQsOSArMTI2LDcgQEAg
bWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJCQl1c2FnZSgpOwogCQl9CiAJfQotCWlm
IChhcmdjIC0gb3B0aW5kICE9IDEpCi0JCXVzYWdlKCk7Ci0JaWYgKGlmbGFnICYmIHhmbGFn
KQorCWlmIChhcmdjIC0gb3B0aW5kICE9IDEgfHwgKChsZmxhZyAmIExPR19FWFQySU5UKSAm
JiAobGZsYWcgJiBMT0dfSU5UMkVYVCkpKQogCQl1c2FnZSgpOwogCWlmIChkZmxhZyArIGxm
bGFnICsgcmZsYWcgKyBtZmxhZyA9PSAwKQogCQlhZmxhZyA9IDE7CkBAIC0zMjMsOSArMzIz
LDkgQEAgXygiW0VYUEVSSU1FTlRBTF0gdHJ5IHRvIHNocmluayB1bnVzZWQgc3BhY2UgJWxs
ZCwgb2xkIHNpemUgaXMgJWxsZFxuIiksCiAKIAkJaWYgKCFsc2l6ZSkKIAkJCWxzaXplID0g
ZGxzaXplIC8gKGdlby5ibG9ja3NpemUgLyBCQlNJWkUpOwotCQlpZiAoaWZsYWcpCisJCWlm
IChsZmxhZyAmIExPR19FWFQySU5UKQogCQkJaW4uaXNpbnQgPSAxOwotCQllbHNlIGlmICh4
ZmxhZykKKwkJZWxzZSBpZiAobGZsYWcgJiBMT0dfSU5UMkVYVCkKIAkJCWluLmlzaW50ID0g
MDsKIAkJZWxzZQogCQkJaW4uaXNpbnQgPSB4aS5sb2dCQnNpemUgPT0gMDsKLS0gCjIuMzMu
MAoK

--------------1WfI1zBWZgb47W4eSd2TTvRP--
