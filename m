Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbeJEIC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 04:02:27 -0400
Date: Thu, 4 Oct 2018 18:06:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] docs: improve readability for people with poorer eyesight
Message-ID: <20181005010603.GA6702@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: corbet@lwn.net
Cc: xfs <linux-xfs@vger.kernel.org>, linux-doc@vger.kernel.org

Hi,

So my eyesight still hasn't fully recovered, so in the meantime it's
been difficult to read the online documentation.  Here's some stylesheet
overrides I've been using to make it easier for me to read them:
https://djwong.org/docs/kdoc/index.html

---
From: Darrick J. Wong <darrick.wong@oracle.com>

My eyesight is not in good shape, which means that I have difficulty
reading the online Linux documentation.  Specifically, body text is
oddly small compared to list items and the contrast of various text
elements is too low for me to be able to see easily.

Therefore, alter the HTML theme overrides to make the text larger and
increase the contrast for better visibility, and trust the typeface
choices of the reader's browser.

For the PDF output, increase the text size, use a sans-serif typeface
for sans-serif text, and use a serif typeface for "roman" serif text.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/conf.py                           |    6 ++--
 Documentation/sphinx-static/theme_overrides.css |   38 +++++++++++++++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index e45d4d2b5adb..03dd6dc135ea 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -259,7 +259,7 @@ latex_elements = {
 'papersize': 'a4paper',
 
 # The font size ('10pt', '11pt' or '12pt').
-'pointsize': '8pt',
+'pointsize': '11pt',
 
 # Latex figure (float) alignment
 #'figure_align': 'htbp',
@@ -272,8 +272,8 @@ latex_elements = {
     'preamble': '''
 	% Use some font with UTF-8 support with XeLaTeX
         \\usepackage{fontspec}
-        \\setsansfont{DejaVu Serif}
-        \\setromanfont{DejaVu Sans}
+        \\setsansfont{DejaVu Sans}
+        \\setromanfont{DejaVu Serif}
         \\setmonofont{DejaVu Sans Mono}
 
      '''
diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index 522b6d4c49d4..e21e36cd6761 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -4,6 +4,44 @@
  *
  */
 
+/* Improve contrast and increase size for easier reading. */
+
+body {
+	font-family: serif;
+	color: black;
+	font-size: 100%;
+}
+
+h1, h2, .rst-content .toctree-wrapper p.caption, h3, h4, h5, h6, legend {
+	font-family: sans-serif;
+}
+
+.wy-menu-vertical li.current a {
+	color: #505050;
+}
+
+.wy-menu-vertical li.on a, .wy-menu-vertical li.current > a {
+	color: #303030;
+}
+
+div[class^="highlight"] pre {
+	font-family: monospace;
+	color: black;
+	font-size: 100%;
+}
+
+.wy-menu-vertical {
+	font-family: sans-serif;
+}
+
+.c {
+	font-style: normal;
+}
+
+p {
+	font-size: 100%;
+}
+
 /* Interim: Code-blocks with line nos - lines and line numbers don't line up.
  * see: https://github.com/rtfd/sphinx_rtd_theme/issues/419
  */
